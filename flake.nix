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

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
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
    in
    {
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
