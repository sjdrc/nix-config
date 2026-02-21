{
  homeModule = {
    config,
    lib,
    ...
  }: {
    options.custom.programs.bash.enable = lib.mkEnableOption "bash configuration";

    config = lib.mkIf config.custom.programs.bash.enable {
      programs.bash = {
        enable = true;
        enableCompletion = true;
        enableVteIntegration = true;

        initExtra = ''
          col="$(echo -n ''${HOSTNAME} | od | awk '{total = total + $1}END{print 31 + (total % 7)}')"
          PS1="\u@\[\e[''${col}m\]\h\[\e[m\]:\w\n\$ "
        '';

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
  };
}
