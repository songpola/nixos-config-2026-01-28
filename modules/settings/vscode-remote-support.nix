{ delib, pkgs, ... }:
delib.module {
  name = "settings.vscodeRemoteSupport";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = [ pkgs.wget ];
    programs.nix-ld.enable = true;
  };
}
