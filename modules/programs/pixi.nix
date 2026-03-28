{
  delib,
  pkgs,
  lib,
  ...
}:
delib.module {
  name = "programs.pixi";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = [ pkgs.pixi ];
  };

  home.ifEnabled = {
    programs.nushell.extraConfig = ''
      source ${
        pkgs.runCommand "pixi-nushell-config.nu" { } ''
          ${lib.getExe pkgs.pixi} completion --shell nushell >> "$out"
        ''
      }
    '';
  };
}
