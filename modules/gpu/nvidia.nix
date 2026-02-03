{
  delib,
  ...
}:
delib.module {
  name = "gpu.nvidia";

  options =
    with delib;
    moduleOptions (
      { parent, ... }:
      {
        enable = boolOption false;

        # The users need to set this option depending on their GPU model
        useOpenSourceKernelModule = noDefault (boolOption null);
      }
    );

  nixos.ifEnabled =
    { cfg, ... }:
    {
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia.open = cfg.useOpenSourceKernelModule;
    };
}
