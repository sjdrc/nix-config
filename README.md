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
