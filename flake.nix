{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/release-25.11";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      nixos-wsl,
      home-manager,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      commonModules = [
        nixos-wsl.nixosModules.default
        home-manager.nixosModules.home-manager
        ./common
      ];
      mkSystem =
        extraModules:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = commonModules ++ extraModules;
          specialArgs = { inherit inputs; };
        };
      mkConfigs =
        names:
        let
          systems = map (name: mkSystem [ ./hosts/${name} ]) names;
        in
        builtins.listToAttrs (lib.zipListsWith lib.nameValuePair names systems);
    in
    {
      nixosConfigurations = mkConfigs [
        "spla-desktop-wsl"
        "spla-laptop-wsl"
      ];
    };
}
