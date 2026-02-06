{
  delib,
  pkgs,
  host,
  ...
}:
delib.module {
  name = "programs.nvitop";

  options = delib.singleEnableOption host.nvidiaFeatured;

  nixos.ifEnabled = {
    environment.systemPackages = [ pkgs.nvitop ];
  };
}
