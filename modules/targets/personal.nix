{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    zen-browser
  ];

  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlp1s0";
}
