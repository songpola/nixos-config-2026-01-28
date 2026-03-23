{
  delib,
  host,
  ...
}:
delib.module {
  name = "virtualization.docker.nvidiaSupport";

  options = args: delib.singleEnableOption (args.parent.enable && host.nvidiaFeatured) args;

  nixos.ifEnabled = {
    hardware.nvidia-container-toolkit.enable = true;
  };
}
