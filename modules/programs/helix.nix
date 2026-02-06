{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.helix";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = [ pkgs.helix ];
  };

  home.ifEnabled = {
    programs.helix.enable = true;
  };
}
