{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/release-25.11";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    denix.url = "github:yunfachi/denix";
    denix.inputs.nixpkgs.follows = "nixpkgs";
    denix.inputs.home-manager.follows = "home-manager";

    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
  };

  outputs =
    {
      nixpkgs,
      nixos-wsl,
      home-manager,
      denix,
      ...
    }@inputs:
    let
      delib = denix.lib;
      # inherit (nixpkgs) lib;
      # commonModules = [
      #   nixos-wsl.nixosModules.default
      #   home-manager.nixosModules.home-manager
      #   ./common
      # ];
      # mkSystem =
      #   extraModules:
      #   nixpkgs.lib.nixosSystem {
      #     system = "x86_64-linux";
      #     modules = commonModules ++ extraModules;
      #     specialArgs = { inherit inputs; };
      #   };
      # mkConfigs =
      #   names:
      #   let
      #     systems = map (name: mkSystem [ ./hosts/${name} ]) names;
      #   in
      #   builtins.listToAttrs (lib.zipListsWith lib.nameValuePair names systems);
    in
    {
      # nixosConfigurations = mkConfigs [
      #   "spla-desktop-wsl"
      #   "spla-laptop-wsl"
      # ];
      nixosConfigurations = delib.configurations {
        moduleSystem = "nixos";
        homeManagerUser = "songpola";

        paths = [
          ./hosts
          ./modules
        ];

        extensions = with delib.extensions; [
          args
          (base.withConfig {
            args.enable = true;
            rices.enable = false;
            hosts = {
              type.types = [ ];
              features.features = [ ];
            };
          })
        ];

        specialArgs = {
          inherit inputs;
        };
      };
    };
}
