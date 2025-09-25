# FIXME(lib.custom): Add some stuff from hmajid2301/dotfiles/lib/module/default.nix, as simplifies option declaration
{lib, ...}:
with lib; {
  scanPaths = path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        attrsets.filterAttrs (
          path: _type:
            (_type == "directory") # include directories
            || (
              (path != "default.nix") # ignore default.nix
              && (strings.hasSuffix ".nix" path) # include .nix files
            )
        ) (builtins.readDir path)
      )
    );

  getHostsList = map (host: builtins.replaceStrings [".nix"] [""] host) (builtins.attrNames (builtins.readDir ../hosts));
}
