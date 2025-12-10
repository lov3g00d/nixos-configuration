{
  description = "NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-24-05.url = "github:nixos/nixpkgs/nixos-24.05";
    catppuccin.url = "github:catppuccin/nix";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-24-05,
      home-manager,
      catppuccin,
      nvf,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs-24-05 = import nixpkgs-24-05 {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            catppuccin.nixosModules.catppuccin

            # Home Manager module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.art = import ./users/art/home.nix;
              home-manager.extraSpecialArgs = { inherit pkgs-24-05; };
              home-manager.sharedModules = [
                catppuccin.homeModules.catppuccin
                nvf.homeManagerModules.default
              ];
            }
          ];
        };
      };
    };
}
