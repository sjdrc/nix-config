# NixOS Configuration

A modular NixOS configuration using the **dendritic flake-parts pattern**: every `.nix` file is a self-contained [flake-parts](https://flake.parts/) module that contributes named outputs to the flake.

## Architecture

### Dendritic Pattern

This repo follows the [dendritic nix pattern](https://github.com/mightyiam/dendritic) — every file is a flake-parts module. This means:

- **One file = one module.** Each `.nix` file defines `flake.nixosModules.<name>` and/or `flake.homeModules.<name>`.
- **Automatic discovery.** `flake.nix` auto-imports all `.nix` files from module and host directories. Adding a new module requires no changes to any import list.
- **Named exports.** Every module is individually addressable (e.g., `nixosModules.kitty`, `homeModules.niri`), but a `nixosModules.default` and `homeModules.default` aggregate all of them for convenience.
- **Feature-centric composition.** Profiles enable groups of modules via `custom.*.enable` options. Hosts compose profiles.

### Directory Structure

```
.
├── flake.nix                    # Entry point — auto-imports all modules
├── flake.lock
├── lib/
│   └── default.nix              # Custom library functions
├── hosts/                       # Host definitions (flake-parts modules)
│   ├── ariel.nix                # → flake.nixosConfigurations.ariel
│   ├── dione.nix                # → flake.nixosConfigurations.dione
│   ├── hyperion.nix             # → flake.nixosConfigurations.hyperion
│   └── pallas.nix               # → flake.nixosConfigurations.pallas
├── modules/
│   ├── system/                  # Core system modules
│   │   ├── audio.nix            # → nixosModules.audio
│   │   ├── bluetooth.nix        # → nixosModules.bluetooth + homeModules.bluetooth
│   │   ├── boot.nix             # → nixosModules.boot
│   │   ├── disks.nix            # → nixosModules.disks
│   │   ├── locale.nix           # → nixosModules.locale
│   │   ├── networking.nix       # → nixosModules.networking
│   │   ├── nix.nix              # → nixosModules.nix + homeModules.nix
│   │   ├── nixpkgs.nix          # → nixosModules.nixpkgs
│   │   ├── platform.nix         # → nixosModules.platform
│   │   ├── stylix.nix           # → nixosModules.stylix
│   │   └── tailscale.nix        # → nixosModules.tailscale
│   ├── programs/                # Program-specific modules
│   │   ├── anyrun.nix           # → homeModules.anyrun
│   │   ├── bash.nix             # → homeModules.bash
│   │   ├── claude-code.nix      # → homeModules.claude-code
│   │   ├── code-server.nix      # → nixosModules.code-server + homeModules.code-server
│   │   ├── kitty.nix            # → homeModules.kitty
│   │   ├── niri.nix             # → nixosModules.niri + homeModules.niri
│   │   ├── nirinit.nix          # → nixosModules.nirinit
│   │   ├── nvim.nix             # → homeModules.nvim
│   │   ├── sshrc.nix            # → homeModules.sshrc
│   │   ├── tmux.nix             # → homeModules.tmux
│   │   ├── tuigreet.nix         # → nixosModules.tuigreet
│   │   ├── vscode.nix           # → homeModules.vscode
│   │   ├── waybar.nix           # → nixosModules.waybar + homeModules.waybar
│   │   ├── wlogout.nix          # → homeModules.wlogout
│   │   └── zen-browser.nix      # → nixosModules.zen-browser + homeModules.zen-browser
│   ├── profiles/                # Composable feature sets
│   │   ├── 3d-printing.nix      # → nixosModules.3d-printing + homeModules.3d-printing
│   │   ├── desktop.nix          # → nixosModules.desktop + homeModules.desktop
│   │   ├── development.nix      # → nixosModules.development + homeModules.development
│   │   ├── gaming.nix           # → nixosModules.gaming + homeModules.gaming
│   │   ├── laptop.nix           # → nixosModules.laptop + homeModules.laptop
│   │   ├── media-server.nix     # → nixosModules.media-server + homeModules.media-server
│   │   ├── shell.nix            # → nixosModules.shell + homeModules.shell
│   │   └── user.nix             # → nixosModules.user + homeModules.user
│   └── hardware/                # Hardware-specific modules
│       ├── cpu-amd.nix          # → nixosModules.cpu-amd
│       ├── cpu-intel.nix        # → nixosModules.cpu-intel
│       ├── gpd-pocket-3.nix     # → nixosModules.gpd-pocket-3 + homeModules.gpd-pocket-3
│       ├── gpu-nvidia.nix       # → nixosModules.gpu-nvidia
│       └── thinkpad-x1-nano.nix # → nixosModules.thinkpad-x1-nano
└── packages/                    # Custom packages
    ├── bambu-studio/
    ├── openlens/
    └── orca-slicer/
```

### Module Anatomy

Every module file is a **flake-parts module** — a function that receives `{ inputs, config, ... }` and returns an attrset setting `flake.*` options.

**System-only module** (e.g., `modules/system/boot.nix`):
```nix
{...}: {
  flake.nixosModules.boot = { config, lib, ... }: {
    options.custom.system.boot.enable = lib.mkEnableOption "..." // { default = true; };
    config = lib.mkIf config.custom.system.boot.enable { ... };
  };
}
```

**Home-only module** (e.g., `modules/programs/kitty.nix`):
```nix
{...}: {
  flake.homeModules.kitty = { config, lib, ... }: {
    options.custom.programs.kitty.enable = lib.mkEnableOption "...";
    config = lib.mkIf config.custom.programs.kitty.enable { ... };
  };
}
```

**Dual module** (e.g., `modules/programs/waybar.nix`):
```nix
{...}: {
  flake.nixosModules.waybar = { config, lib, pkgs, ... }: {
    options.custom.programs.waybar.enable = lib.mkEnableOption "...";
    config = lib.mkIf config.custom.programs.waybar.enable { ... };
  };
  flake.homeModules.waybar = { config, lib, osConfig, ... }: {
    config = lib.mkIf osConfig.custom.programs.waybar.enable { ... };
  };
}
```

**Host module** (e.g., `hosts/dione.nix`):
```nix
{ inputs, config, ... }: {
  flake.nixosConfigurations.dione = inputs.nixpkgs.lib.nixosSystem {
    modules = [ config.flake.nixosModules.default { ... } ];
    specialArgs = { inherit inputs; lib = config.flake.lib; };
  };
}
```

### How Profiles Work

Profiles are modules that enable other modules. They define a single `custom.profiles.<name>.enable` option and, when enabled, set `custom.programs.*.enable = true` for the programs they compose:

```
desktop profile
├── nixosModule: enables niri, nirinit, tuigreet, waybar (system-level)
└── homeModule:  enables kitty, anyrun, wlogout, zen-browser (user-level)
```

Hosts compose profiles:
```nix
custom.profiles.desktop.enable = true;
custom.profiles.development.enable = true;
custom.profiles.gaming.enable = true;
```

### Option Namespace

All custom options live under the `custom` namespace:

- `custom.system.*` — System infrastructure (audio, boot, networking, etc.)
- `custom.programs.*` — Individual programs (kitty, niri, vscode, etc.)
- `custom.profiles.*` — Composable feature sets (desktop, development, gaming, etc.)
- `custom.hardware.*` — Hardware support (cpu.intel, gpu.nvidia, gpd-pocket-3, etc.)

System modules default to `enable = true`. Programs and profiles default to `false` unless explicitly set.

### Aggregation

`flake.nix` defines `nixosModules.default` and `homeModules.default` which aggregate all named modules. This means every host gets all option definitions (even for disabled modules), keeping the enable/disable pattern ergonomic.

The `user.nix` profile handles home-manager integration: it imports `home-manager.nixosModules.home-manager`, creates the system user, and wires up `homeModules.default` for that user.

## How To

### Add a new program

1. Create `modules/programs/<name>.nix`
2. Define `flake.homeModules.<name>` (and optionally `flake.nixosModules.<name>`)
3. Add `options.custom.programs.<name>.enable = lib.mkEnableOption "...";`
4. Enable it from a profile or host

No other files need to change — auto-import handles discovery.

### Add a new host

1. Create `hosts/<hostname>.nix`
2. Define `flake.nixosConfigurations.<hostname>` using `inputs.nixpkgs.lib.nixosSystem`
3. Import `config.flake.nixosModules.default` and enable desired profiles

### Add a new profile

1. Create `modules/profiles/<name>.nix`
2. Define `flake.nixosModules.<name>` and `flake.homeModules.<name>`
3. Add `options.custom.profiles.<name>.enable = lib.mkEnableOption "...";`
4. In the config block, enable the programs/modules this profile composes

## Design Decisions

### Why flake-parts dendritic pattern?

- **Clarity**: Each file has a single responsibility and contributes named flake outputs. No indirection through loader scripts.
- **Discoverability**: The flake output names match file names. `nixosModules.kitty` lives in `programs/kitty.nix`.
- **Extensibility**: Adding modules requires zero boilerplate — just create a file and define the flake-parts module.
- **Standard interfaces**: Every module uses the standard NixOS module system (`mkEnableOption`, `mkIf`, `config`/`options`). No custom wrapper functions.

### Why keep nixosModules.default aggregation?

The dendritic pattern gives named modules, but aggregation into `default` preserves the ergonomic enable/disable pattern. Without it, hosts would need to explicitly import every module they use, and you couldn't set `custom.programs.kitty.enable = false` unless the kitty module was imported.

### Why separate nixosModules and homeModules?

NixOS system config and home-manager user config are separate module systems with different evaluation contexts. Keeping them as separate named exports (`nixosModules.niri` vs `homeModules.niri`) makes the boundary explicit. The `user.nix` profile wires them together via `home-manager.users.<name>.imports`.

### Inputs access

Modules that need flake inputs (e.g., to import an external NixOS module) access them through:
1. The flake-parts module argument: `{ inputs, ... }: { flake.nixosModules.foo = ... }`
2. NixOS `specialArgs`: `{ inputs, ... }:` in the inner NixOS module function

### Related projects and patterns

- [Dendritic pattern](https://github.com/mightyiam/dendritic) — the configuration pattern this repo follows
- [flake-parts](https://flake.parts/) — the module framework for Nix flakes
- [nixos-unified](https://github.com/srid/nixos-unified) — flake-parts integration for NixOS
- [import-tree](https://github.com/vic/import-tree) — automatic module discovery (this repo uses a simpler built-in version)

---

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
