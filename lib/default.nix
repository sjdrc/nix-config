# Custom library functions for NixOS configuration
{...}: {
  # Get list of host names from the hosts/ directory
  # Used to automatically generate nixosConfigurations
  # Only includes .nix files (excluding default.nix if present)
  getHostsList =
    map
    (f: builtins.replaceStrings [".nix"] [""] f)
    (builtins.filter
      (f: f != "default.nix" && builtins.match ".*\\.nix" f != null)
      (builtins.attrNames (builtins.readDir ../hosts)));
}
