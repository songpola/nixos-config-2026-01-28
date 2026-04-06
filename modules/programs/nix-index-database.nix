{
  delib,
  inputs,
  pkgs,
  ...
}:
delib.module {
  name = "programs.nix-index-database";

  options = delib.singleEnableOption false;

  nixos.always =
    { cfg, ... }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          # https://github.com/NixOS/nixpkgs/pull/490443
          nix-index = pkgs.unstable.nix-index;
        })
      ];

      imports = [ inputs.nix-index-database.nixosModules.default ];

      programs.nix-index.enable = cfg.enable;
    };

  home.always =
    { cfg, ... }:
    {
      imports = [ inputs.nix-index-database.homeModules.default ];

      programs.nix-index.enable = cfg.enable;
    };
}
