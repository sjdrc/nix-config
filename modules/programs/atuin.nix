{...}: {
  flake.homeModules.atuin = {osConfig, lib, ...}: lib.mkIf osConfig.custom.atuin.enable {
    programs.atuin = {
      enable = true;
      flags = ["--disable-up-arrow"];
      settings = {
        filter_mode = "global";
        search_mode = "prefix";
      };
    };

    programs.bash.initExtra = ''
      # Up arrow: session history when empty, global prefix search when text typed
      _atuin_smart_up() {
        if [[ -z "$READLINE_LINE" ]]; then
          __atuin_history --shell-up-key-binding --filter-mode session
        else
          __atuin_history --shell-up-key-binding --filter-mode global
        fi
      }
      bind -x '"\e[A": _atuin_smart_up'
      bind -x '"\eOA": _atuin_smart_up'
    '';
  };

  flake.nixosModules.atuin = {lib, ...}: {
    options.custom.atuin.enable = lib.mkEnableOption "atuin shell history";
  };
}
