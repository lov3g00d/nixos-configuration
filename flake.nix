{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-24-05.url = "github:nixos/nixpkgs/nixos-24.05"; # google-cloud-sdk compatibility
    catppuccin.url = "github:catppuccin/nix";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-24-05,
    home-manager,
    catppuccin,
    nvf,
    nix-index-database,
    ...
  }: let
    system = "x86_64-linux";
    pkgs-24-05 = import nixpkgs-24-05 {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            users.art = import ./users/art/home;
            extraSpecialArgs = {inherit pkgs-24-05;};
            sharedModules = [
              catppuccin.homeModules.catppuccin
              nvf.homeManagerModules.default
              nix-index-database.homeModules.nix-index
            ];
          };
        }
      ];
    };

    devShells.${system}.default = let
      pkgs = import nixpkgs {inherit system;};
    in
      pkgs.mkShell {
        name = "nixos-config";
        packages = with pkgs; [
          nil
          nixfmt-rfc-style
          statix
          deadnix
          manix
          nix-tree
          nix-diff
          nvd
          nix-output-monitor
        ];
      };
  };
}
