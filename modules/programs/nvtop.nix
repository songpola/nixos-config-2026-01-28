{
  delib,
  pkgs,
  host,
  ...
}:
delib.module {
  name = "programs.nvtop";

  options = delib.singleEnableOption host.nvidiaFeatured;

  nixos.ifEnabled = {
    environment.systemPackages = [ pkgs.nvtopPackages.nvidia ];
  };
}
