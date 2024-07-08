{ inputs, lib, config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
  };
}
