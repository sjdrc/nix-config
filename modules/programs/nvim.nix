{inputs, ...}: {
  flake.homeModules.nvim = {osConfig, lib, ...}: {
    imports = [inputs.nvf.homeManagerModules.default];

    config = lib.mkIf osConfig.custom.nvim.enable {
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
  };

  flake.nixosModules.nvim = {lib, ...}: {
    options.custom.nvim.enable = lib.mkEnableOption "neovim";
  };
}
