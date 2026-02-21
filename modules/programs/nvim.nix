flakeArgs @ {inputs, ...}: {
  flake.homeModules.nvim = {...}: {
    imports = [inputs.nvf.homeManagerModules.default];

    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;
          lsp.enable = false;
          clipboard.registers = ["unnamedplus"];
          searchCase = "ignore";
          options = {
            wrap = false;
          };
        };
      };
    };
  };

  flake.nixosModules.nvim = {config, lib, ...}: {
    options.custom.nvim.enable = lib.mkEnableOption "neovim";
    config = lib.mkIf config.custom.nvim.enable {
      home-manager.sharedModules = [flakeArgs.config.flake.homeModules.nvim];
    };
  };
}
