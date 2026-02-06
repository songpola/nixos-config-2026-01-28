{
  delib,
  pkgs,
  host,
  ...
}:
delib.module {
  name = "programs.btop";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;

      cuda = boolOption host.nvidiaFeatured;
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      environment.systemPackages = [
        (if cfg.cuda then pkgs.btop-cuda else pkgs.btop)
      ];
    };
}
