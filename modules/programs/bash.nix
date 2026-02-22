{...}: {
  flake.homeModules.bash = {osConfig, lib, ...}: lib.mkIf osConfig.custom.bash.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;

      shellOptions = [
        "autocd"
        "cdspell"
        "expand_aliases"
      ];

      shellAliases = {
        l = "ls";
        s = "sudo";
        sc = "systemctl-tui";
        ssc = "systemctl-tui";
        dc = "docker-compose";
        pg = "ping -c1 1.1.1.1 && host -t a fsf.org";
        cx = "sudo chmod +x";
        co = "sudo chown $${USER}:$$(id -gn $${USER})";
        cor = "sudo chown -R $${USER}:$$(id -gn $${USER})";
        mkdir = "mkdir -p";
        rmr = "rm -r";
        rmrf = "rm -rf";
        srmr = "sudo rm -r";
        srmrf = "sudo rm -rf";
        ssh = "sshrc";
      };
    };
  };

  flake.nixosModules.bash = {lib, ...}: {
    options.custom.bash.enable = lib.mkEnableOption "bash configuration";
  };
}
