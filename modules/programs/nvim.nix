{inputs, ...}: {
  home-manager.users.sebastien = {
    imports = [inputs.nvf.homeManagerModules.default];
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          viAlias = true;
          vimAlias = true;
          lsp.enable = false;
          useSystemClipboard = true;
          searchCase = "ignore";
          options = {
            wrap = false;
          };
        };
      };
    };
  };
}
