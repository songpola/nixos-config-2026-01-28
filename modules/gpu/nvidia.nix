{
  delib,
  host,
  ...
}:
delib.module {
  name = "gpu.nvidia";

  options =
    with delib;
    moduleOptions (
      { myconfig, ... }:
      {
        enable = boolOption host.nvidiaFeatured;

        # The users need to set this option depending on their GPU model
        useOpenSourceKernelModule = noDefault (boolOption null);

        enableContainerToolkit = boolOption false;
      }
    );

  nixos.ifEnabled =
    { cfg, ... }:
    {
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia.open = cfg.useOpenSourceKernelModule;

      hardware.nvidia-container-toolkit.enable = cfg.enableContainerToolkit;
    };
}
