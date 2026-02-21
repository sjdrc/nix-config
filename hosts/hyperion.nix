flakeArgs @ {inputs, ...}: {
  flake.nixosConfigurations.hyperion = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with flakeArgs.config.flake.nixosModules; [
      system user shell laptop
      thinkpad-x1-nano
      {
        imports = [
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
        ];
        networking.hostName = "hyperion";
        nixpkgs.overlays = [
          inputs.self.overlays.default
          inputs.nix-vscode-extensions.overlays.default
        ];
        custom.laptop.enable = true;
        custom.thinkpad-x1-nano.enable = true;
      }
    ];
    specialArgs = {inherit inputs;};
  };
}
