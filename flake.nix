{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Fast-moving channel used for packages whose upstreams yank releases (e.g. claude-code).
    # nixos-unstable is gated on Hydra and can lag by days, long enough for an npm yank to brick the build.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-25-05.url = "github:nixos/nixpkgs/nixos-25.05"; # argocd v2 compat (cluster still on v2.x)
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-25-05,
    nixos-hardware,
    home-manager,
    catppuccin,
    nvf,
    nix-index-database,
    lanzaboote,
    niri,
    ...
  }: let
    system = "x86_64-linux";
    pkgs-25-05 = import nixpkgs-25-05 {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
    sharedFeeds = import ./data/feeds.nix;
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit sharedFeeds;};
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
        catppuccin.nixosModules.catppuccin
        niri.nixosModules.niri
        lanzaboote.nixosModules.lanzaboote
        home-manager.nixosModules.home-manager
        {nixpkgs.overlays = [niri.overlays.niri];}
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            users.art = import ./users/art/home;
            extraSpecialArgs = {inherit pkgs-25-05 pkgs-unstable sharedFeeds;};
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
