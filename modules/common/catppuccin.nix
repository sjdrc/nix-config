{ inputs, config, ... }:
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  home-manager.users.${config.user} = {
    imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
    gtk.catppuccin.enable = true;
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
