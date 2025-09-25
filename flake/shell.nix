{inputs, ...}: {
  flake = {
    nixosModules.default = {pkgs, ...}: with pkgs; {
      fonts.packages = [nerd-fonts.fira-code];
      users.defaultUserShell = bash;
      environment.systemPackages = [
        systemctl-tui
        bluetuith
        lnav
      ];
    };
    homeModules.default = {pkgs, ...}: {
      imports = [inputs.nvf.homeManagerModules.default];
      programs.tmux = {
        enable = true;
        clock24 = true;
        focusEvents = true;
        historyLimit = 10000;
        mouse = true;
        newSession = true;
        extraConfig = ''
          bind-key e set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"
        '';
      };
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
      programs = {
        bash = {
          enable = true;
          enableCompletion = true;
          enableVteIntegration = true;
          initExtra = ''
            col="''$(echo -n ''${HOSTNAME} | od | awk '{total = total + ''$1}END{print 31 + (total % 7)}')"
            PS1="\u@\[\e[''${col}m\]\h\[\e[m\]:\w\n\''$ "
            bind '"\e[A": history-search-backward'
            bind '"\e[B": history-search-forward'
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
        fzf.enable = true;
        fzf.tmux.enableShellIntegration = true;
        atuin.enable = true;
        htop.enable = true;
        starship.enable = true;
        eza = {
          enable = true;
          extraOptions = [
            "--group-directories-first"
            "--header"
          ];
          git = true;
          icons = "auto";
        };
      };
      home.packages = with pkgs; [
        wget
        systemctl-tui
        bluetuith
        lnav
        # Docker tools
        lazydocker
        dive
      ];
    };
  };
}
