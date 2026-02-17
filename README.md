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

# Todo
* clipboard
    * history
    * manager
* launcher
    * rofi styling
    * other launchers
