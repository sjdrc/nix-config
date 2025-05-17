{...}: {
  programs.zsh.enable = true;
  home-manager.users.sebastien = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;

      autocd = true;
      autosuggestion.enable = true;
      oh-my-zsh.enable = true;
      syntaxHighlighting.enable = true;

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
}
