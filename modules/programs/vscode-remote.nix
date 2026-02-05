{ delib, pkgs, ... }:
delib.module {
  name = "programs.vscodeRemote";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = [ pkgs.wget ];
    programs.nix-ld.enable = true;
  };
}
