{inputs, ...}: {
  #home-manager.sharedModules = [inputs.nvf.homeManagerModules.default];
  home-manager.users.sebastien = {
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
}
