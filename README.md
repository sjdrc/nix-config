# Architecture

This NixOS configuration uses a **dendritic (tree-shaped) flake-parts module** pattern.
Every `.nix` file is a self-contained flake-parts module that registers its outputs
(`flake.nixosModules.*`, `flake.homeModules.*`, or `flake.nixosConfigurations.*`)
in a flat namespace. There are no auto-loaders — the import tree is explicit.

## Key concepts

### Module layers

There are two module systems at play, and every file participates in one or both:

| Layer | Purpose | Registered as |
|-------|---------|---------------|
| **Flake-parts** | Wires the flake together | `imports = [./foo.nix]` in another flake-parts module |
| **NixOS** | Configures a machine | `flake.nixosModules.<name>` |
| **Home Manager** | Configures a user session | `flake.homeModules.<name>` |

### The `flakeArgs @` pattern

NixOS modules and flake-parts modules both receive a `config` argument, but they
refer to different things. To reference flake-level outputs (like `homeModules`)
from inside a NixOS module definition, we capture the flake-parts args:

```nix
flakeArgs @ {...}: {                              # flake-parts module args
  flake.homeModules.foo = {...}: { /* HM config */ };

  flake.nixosModules.foo = {config, lib, ...}: {  # NixOS module args
    options.custom.foo.enable = lib.mkEnableOption "foo";
    config = lib.mkIf config.custom.foo.enable {
      # 'config' here is NixOS config
      # 'flakeArgs.config' is flake-parts config
      home-manager.sharedModules = [flakeArgs.config.flake.homeModules.foo];
    };
  };
}
```

This is safe because Nix evaluates lazily — the `flakeArgs.config.flake.homeModules.foo`
thunk isn't forced until `nixosSystem` processes it, by which point all flake-parts
modules have been evaluated.

### Option namespace

All custom options live under `custom.<name>.enable` in a flat namespace:

| Old path | New path |
|----------|----------|
| `custom.profiles.desktop.enable` | `custom.desktop.enable` |
| `custom.programs.niri.enable` | `custom.niri.enable` |
| `custom.system.boot.enable` | `custom.boot.enable` |
| `custom.hardware.cpu.intel.enable` | `custom.cpu-intel.enable` |
| `custom.profiles.user.name` | `custom.user.name` |

## File structure

```
flake.nix                        # Entry point — imports ./hosts
hosts/
  default.nix                    # Aggregator: imports all modules + host files
  dione.nix                      # flake.nixosConfigurations.dione
  ariel.nix                      # flake.nixosConfigurations.ariel
  ...
modules/
  system/
    default.nix                  # Aggregator: imports children, exports flake.nixosModules.system
    boot.nix                     # flake.nixosModules.boot
    nix.nix                      # flake.nixosModules.nix + flake.homeModules.nix
    ...
  programs/
    niri.nix                     # flake.nixosModules.niri + flake.homeModules.niri
    kitty.nix                    # flake.nixosModules.kitty + flake.homeModules.kitty
    ...
  hardware/
    cpu-intel.nix                # flake.nixosModules.cpu-intel
    gpd-pocket-3.nix             # flake.nixosModules.gpd-pocket-3 + flake.homeModules.gpd-pocket-3
    ...
  desktop.nix                    # Composition: imports programs/*, exports desktop nixos+home modules
  development.nix                # Composition: imports programs/*, exports development modules
  shell.nix                      # Composition: imports programs/*, exports shell modules
  laptop.nix                     # Composition: exports laptop modules
  user.nix                       # Sets up home-manager and the primary user
  ...
```

## Module categories

### Leaf modules (`modules/programs/`, `modules/system/`, `modules/hardware/`)

Self-contained units. Each registers one or both of:
- `flake.nixosModules.<name>` — NixOS config with an `options.custom.<name>.enable`
- `flake.homeModules.<name>` — Home Manager config, injected via `home-manager.sharedModules`

### Composition modules (`modules/*.nix` — desktop, shell, development, etc.)

Import their children at the flake-parts level, then compose them:
- At the **flake-parts level**: `imports = [./programs/niri.nix ./programs/kitty.nix ...]`
- At the **NixOS level**: `imports = with flakeArgs.config.flake.nixosModules; [niri kitty ...]`
- Enable children: `custom.niri.enable = true; custom.kitty.enable = true;`
- Inject own homeModule: `home-manager.sharedModules = [flakeArgs.config.flake.homeModules.desktop]`

### System aggregator (`modules/system/default.nix`)

Imports all system children and creates `flake.nixosModules.system` which bundles them.
All system modules default to `enable = true`.

### Host modules (`hosts/*.nix`)

Define `flake.nixosConfigurations.<hostname>` using `nixosSystem`. Each host:
1. Lists its NixOS modules: `modules = with flakeArgs.config.flake.nixosModules; [system user shell desktop ...]`
2. Sets enables and host-specific config in an inline module
3. Imports hardware-specific third-party modules from `nixos-hardware`

## Design decisions

- **No auto-loaders**: The old `modules-loader.nix` / `homeModules-loader.nix` pattern
  was replaced with explicit imports. This makes the dependency tree visible and
  ensures unused modules aren't loaded.

- **homeModules injected via sharedModules**: Instead of a global home-module auto-loader,
  each NixOS module injects its homeModule via `home-manager.sharedModules` when enabled.
  This means home config is only applied for modules that are actually enabled.

- **NixOS module deduplication**: NixOS deduplicates modules by identity, so if multiple
  composition modules import the same child (e.g., both desktop and development import
  `nvim`), it's safely deduplicated.

- **Flat option namespace**: Eliminates the old `profiles`/`programs`/`system`/`hardware`
  hierarchy. Every option is `custom.<name>.enable`, making references shorter and
  removing the need to know which category a module belongs to.

# Known Issues

## Niri screen sharing: no window-level selection in browsers

**Status:** Workaround in place, waiting for upstream fix.

Niri's GNOME portal screencast has a DMA-BUF format negotiation bug that causes
PipeWire to fail with "no more input formats" when browsers (Firefox/Zen) try to
consume the stream. This breaks screen sharing in Google Meet, etc.

**Upstream issues:**
- https://github.com/YaLTeR/niri/issues/455 (SHM screen capture support)
- https://github.com/YaLTeR/niri/pull/1791 (SHM support PR - not yet merged)
- https://github.com/YaLTeR/niri/issues/2808 (screen sharing inconsistencies)
- https://github.com/YaLTeR/niri/issues/3145 (format negotiation failure)

**Current workaround (`niri.nix`):**
- ScreenCast portal routed to `xdg-desktop-portal-wlr` instead of GNOME portal.
- WLR portal works but only supports full-monitor sharing (no window picker),
  because niri doesn't implement `ext-foreign-toplevel-list-v1`.
- Niri's Dynamic Cast Target feature (keybinds to switch shared window mid-stream)
  only works through the GNOME portal, so it's not usable with this workaround.

**To revisit:** Check if PR #1791 has been merged into niri. If so, switch
ScreenCast back to the GNOME portal (`["gnome"]` instead of `["wlr"]` in
`niri.nix` portal config) and remove `xdg-desktop-portal-wlr` from extraPortals.
The GNOME portal provides a proper window/monitor picker dialog and supports
niri's Dynamic Cast Target for switching the shared window mid-stream.

## Wlogout: custom stylix integration

**Status:** Using custom implementation, waiting for upstream stylix support.

`wlogout.nix` has a custom stylix integration that references base16 colors, fonts,
and opacity from stylix config, and generates colored icons at build time using
imagemagick (recoloring wlogout's bundled SVG assets). This approach is based on
the upstream stylix PR for wlogout support.

**Upstream PR:**
- https://github.com/nix-community/stylix/pull/1645 (wlogout target)

**To revisit:** Check if PR #1645 has been merged into stylix. If so, remove the
custom color/font/icon logic from `wlogout.nix` and enable the upstream target
via `stylix.targets.wlogout.enable = true` (or whatever the final API is).

## NVIDIA + Plymouth: low-res LUKS decryption prompt

**Status:** Cosmetic, NVIDIA DRM limitation.

The Plymouth boot splash during LUKS decryption renders at low resolution because
it uses the EFI framebuffer (simpledrm), not the NVIDIA GPU. Loading NVIDIA modules
in the initrd (`boot.initrd.kernelModules`) fixes the resolution but breaks Plymouth
entirely — NVIDIA DRM doesn't support the dumb buffer API that Plymouth's renderer
needs, causing it to fall back to text mode. Additionally, adding NVIDIA to initrd
removes `plymouth-switch-root-initramfs.service` from the build.

**Attempted fixes:**
- `boot.initrd.kernelModules` with NVIDIA modules: fixes resolution but breaks Plymouth
- `boot.initrd.availableKernelModules`: same result (udev loads NVIDIA during initrd)
- `initcall_blacklist=simpledrm_platform_driver_init`: Plymouth has no device at all
- `systemd.services.greetd.wants = ["dev-dri-card1.device"]`: device unit unreliable

**To revisit:** Check if NVIDIA's open kernel modules gain dumb buffer support for
Plymouth, or if Plymouth adds a renderer that works with NVIDIA DRM.

## NVIDIA + tuigreet: brief misposition on first render

**Status:** Cosmetic, accepted trade-off.

tuigreet briefly renders in the top-left corner before snapping to center. This
happens because greetd starts before the NVIDIA DRM device is ready, so the TTY
is still at the simpledrm resolution. It corrects itself within ~1 second.
Loading NVIDIA in the initrd fixes this but breaks Plymouth (see above).

## Niri session: "import-environment" deprecation warning

**Status:** Cosmetic, waiting for upstream fix.

On login, the message "calling import-environment without a list of variable names
is deprecated" briefly appears. This comes from the upstream `niri-session` script
calling `systemctl --user import-environment` without arguments, which systemd 258+
warns about. No functional impact.

**Upstream issues:**
- https://github.com/YaLTeR/niri/issues/254
- https://github.com/YaLTeR/niri/discussions/2780

**To revisit:** Check if the niri-session script has been updated to either drop the
call or pass explicit variable names.

# Todo
* clipboard
    * history
    * manager
