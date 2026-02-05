{ delib, pkgs, ... }:
delib.module {
  name = "programs.fzf";

  options = delib.singleEnableOption true;

  nixos.ifEnabled = {
    environment.systemPackages = [ pkgs.fzf ];
  };

  home.ifEnabled = {
    programs.fzf.enable = true;
  };
}
