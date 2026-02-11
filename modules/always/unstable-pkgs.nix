{ inputs, config, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.unstable {
        system = final.stdenv.hostPlatform.system;
        config = config.nixpkgs.config;
      };
    })
  ];
}
