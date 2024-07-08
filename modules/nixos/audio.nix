{ inputs, lib, config, pkgs, ... }:
{
  # Audio device configuration
  #services.pipewire.wireplumber.extraConfig."50-alsa-rename" = {
  #  rule = {
  #    matches = {
  #      {
  #        { "api.alsa.path", "equals", "hw:4" },
  #      },
  #    },
  #    apply_properties = {
  #      ["node.description"] = "Behringer",
  #      ["node.nick"] = "Behringer",
  #    },
  #  }
  #  
  #  table.insert(alsa_monitor.rules,rule)
  #};
}
