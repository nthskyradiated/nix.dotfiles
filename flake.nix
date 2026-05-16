{
  description = "My NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixCats-nvim = {
      url = "path:./config/nixcats-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/HyprLand/v0.55.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, hyprland, nixCats-nvim, ... }:
    let
      system = "x86_64-linux";
      username = "andy";
      hostname = "nixos";
      userEmail = "andy.pandaan@outlook.com";
      timezone = "Asia/Dubai";

    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit username hostname timezone hyprland;
        };

        modules = [
          ./configuration.nix
          {
            nixpkgs.config.allowUnfree = true;
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home.nix;

            home-manager.extraSpecialArgs = {
              inherit username userEmail hostname hyprland nixCats-nvim;
            };
          }
        ];
      };
    };
}
