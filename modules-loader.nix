# Helper module to load all our custom modules
{inputs, ...}: let
  self = inputs.self;

  # Helper to import a module and extract nixosModule
  importNixosModule = path: let
    imported = import path;
    # Check if it's a function (profiles/programs) or a set (system modules)
    module =
      if builtins.isFunction imported
      then imported {inherit inputs self;}
      else imported;
  in
    # Extract nixosModule if present
    # If there's no nixosModule (home-only module), return empty module
    if builtins.isAttrs module && module ? nixosModule
    then module.nixosModule
    else {};

  # Get all .nix files from a directory and import them
  getModules = dir: let
    files = builtins.attrNames (builtins.readDir dir);
    nixFiles = builtins.filter (f: f != "default.nix" && builtins.match ".*\\.nix" f != null) files;
  in
    map (f: importNixosModule (dir + "/${f}")) nixFiles;
in {
  imports =
    (getModules ./modules/system)
    ++ (getModules ./modules/profiles)
    ++ (getModules ./modules/programs)
    ++ (getModules ./modules/hardware);
}
