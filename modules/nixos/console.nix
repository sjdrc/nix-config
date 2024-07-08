{ inputs, lib, config, pkgs, ... }:
{
  boot.loader.systemd-boot.consoleMode = "0"; 
  
  console = {
    earlySetup = true;
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i32b.psf.gz";
  };

}
