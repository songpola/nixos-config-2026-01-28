{ delib, pkgs, ... }:
delib.module {
  name = "programs.zellij";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = [ pkgs.zellij ];
  };

  home.ifEnabled = {
    programs.zellij.enable = true;
  };
}
