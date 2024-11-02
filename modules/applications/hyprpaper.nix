{pkgs, ...}: let
  wallpaper = pkgs.fetchurl {
    url = "https://images.pexels.com/photos/956999/milky-way-starry-sky-night-sky-star-956999.jpeg";
    hash = "sha256-WP1FSJEr5IPQK/QBx/q4NS3ZopUR0yWsXHeBm0gGozU=";
  };
in {
  home-manager.users.sebastien.services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [(builtins.toString wallpaper)];

      wallpaper = [",${builtins.toString wallpaper}"];
    };
  };
}
