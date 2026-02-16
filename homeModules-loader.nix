# Helper module to load all homeModules for standalone home-manager
{inputs, ...}: let
  self = inputs.self;

  # Helper to import a module and extract homeModule
  importHomeModule = path: let
    imported = import path;
    # Check if it's a function (profiles/programs) or a set (system modules)
    module =
      if builtins.isFunction imported
      then imported {inherit inputs self;}
      else imported;
  in
    # Extract homeModule if present, otherwise return empty module
    if builtins.isAttrs module && module ? homeModule
    then module.homeModule
    else {};

  # Get all .nix files from a directory and import their homeModules
  getHomeModules = dir: let
    files = builtins.attrNames (builtins.readDir dir);
    # Filter out default.nix and user.nix (imported manually)
    nixFiles =
      builtins.filter (
        f:
          f
          != "default.nix"
          && f != "user.nix"
          && # user.nix homeModule is imported manually in user.nix nixosModule
          builtins.match ".*\\.nix" f != null
      )
      files;
  in
    map (f: importHomeModule (dir + "/${f}")) nixFiles;
in {
  imports =
    (getHomeModules ./modules/system)
    ++ (getHomeModules ./modules/profiles)
    ++ (getHomeModules ./modules/programs);
}
