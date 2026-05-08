{
  delib,
  host,
  ...
}:
delib.module {
  name = "virtualization.podman.enableNvidia";

  options = args: delib.singleEnableOption (args.parent.enable && host.nvidiaFeatured) args;

  myconfig.ifEnabled = {
    gpu.nvidia.enableContainerToolkit = true;
  };
}
