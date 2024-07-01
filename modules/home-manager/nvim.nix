{ inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    opts = {
      wrap = false;
      # Line numbers
      number = true;
      relativenumber = true;
      # Always show the signcolumn, otherwise test would be shifted when displaying error icons
      signcolumn = "yes";
      # Search
      ignorecase = true;
      smartcase = true;
      incsearch = true;
      hlsearch = true;
      # Tab defaults
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 4;
      expandtab = false;
      # Show line and column when searching
      ruler = true;
      # Global substitution by default
      gdefault = true;
      # Start scrolling when the curser is X lines away from edge of screen
      scrolloff = 5;
      # Show command mode in bottom bar
      showcmd = true;
      # Highlight matching parentheses
      showmatch = true;
      clipboard.register = [ "unnamed" "unnamedplus" "autoselect" ];
    };
    plugins = {
      yanky.enable = true;
    };
  };
}
