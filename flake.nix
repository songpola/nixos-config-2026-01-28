{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    # https://github.com/nix-community/nix-index/issues/287
    # https://github.com/nix-community/nix-index-database/pull/164
    nix-index-database.url = "github:nix-community/nix-index-database/pull/164/head";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-dokploy.url = "github:el-kurto/nix-dokploy";
    nix-dokploy.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { denix, ... }@inputs:
    {
      nixosConfigurations = denix.lib.configurations {
        moduleSystem = "nixos";
        homeManagerUser = "songpola";

        paths = [
          ./hosts
          ./modules
        ];

        extensions = with denix.lib.extensions; [
          args
          (base.withConfig {
            args.enable = true;
            rices.enable = false;
            hosts = {
              type.types = [
                "wsl"
                "server"
              ];
              features.features = [ "nvidia" ];
            };
          })
        ];

        specialArgs = {
          inherit inputs;
        };
      };
    };
}
