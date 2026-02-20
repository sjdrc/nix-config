{inputs, ...}: {
  flake.homeModules.nvim = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.nvf.homeManagerModules.default];

    options.custom.programs.nvim.enable = lib.mkEnableOption "neovim";

    config = lib.mkIf config.custom.programs.nvim.enable {
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
}
