{
  description = "Yaroslav's NixOS desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/3ec636362e1816bc2f0888fa0fa2c69f1bc9e504";
    noctalia.url = "github:noctalia-dev/noctalia/8daaa253ac3ea793677f53b4d0be5dc1dd88f8e4";
  };

  outputs = { self, nixpkgs, noctalia, ... }:
    {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit noctalia; };
        modules = [ ./hosts/desktop/configuration.nix ];
      };
    };
}
