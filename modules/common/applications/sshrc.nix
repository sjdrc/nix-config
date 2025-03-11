{pkgs, ...}: {
  home-manager.users.sebastien = {
    home.file = {
      ".sshrc".text = ''
        HISTFILESIZE=100000
        HISTSIZE=10000
        shopt -s autocd
        shopt -s cdspell
        shopt -s expand_aliases
        alias co='sudo chown $USER:$(id -gn $USER)'
        alias cor='sudo chown -R $USER:$(id -gn $USER)'
        alias cx='sudo chmod +x'
        alias dc='docker-compose'
        alias ls='ls -lh --color'
        alias l='ls'
        alias la='ls -a'
        alias mkdir='mkdir -p'
        alias pg='ping -c1 1.1.1.1 && host -t a fsf.org'
        alias rmr='rm -r'
        alias rmrf='rm -rf'
        alias s='sudo'
        alias sc='sudo systemctl'
        alias srmr='sudo rm -r'
        alias srmrf='sudo rm -rf'
        alias apti='sudo apt install'
        alias aptr='sudo apt purge'
        alias sshkeygen='ssh-keygen -o -a 100 -t ed25519'
        PS1="\u@\[\e[$(echo -n $HOSTNAME | od | awk '{total = total + $1}END{print 31 + (total % 7)}')m\]\h\[\e[m\]:\w\n\$ "
        bind '"\e[A": history-search-backward'
        bind '"\e[B": history-search-forward'
      '';
    };
    home.packages = [
      (pkgs.writeScriptBin "sshrc" ''
        #/usr/bin/env bash
        [ -z "''${SSHRC}" ] && SSHRC="$(base64 < .sshrc)"
        exec ssh -t $@ "$(cat <<-EOF
          export TERM="xterm-256color"
          export SSHRC="''${SSHRC}"
          exec "\''${BASH}" --rcfile <(printf %s "\''${SSHRC}" | base64 -d) -i
        EOF
        )"
      '')
    ];
  };
}
