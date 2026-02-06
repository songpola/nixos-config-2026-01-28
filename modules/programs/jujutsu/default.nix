{
  delib,
  pkgs,
  lib,
  myconfig,
  ...
}:
delib.module {
  name = "programs.jujutsu";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;

      # Inherit settings from the Git module.
      inheritFromGit = boolOption false;
    };

  nixos.ifEnabled = {
    environment.systemPackages = [ pkgs.jujutsu ];
  };

  home.ifEnabled = {
    programs.jujutsu.enable = true;
  };

  myconfig.ifEnabled =
    { cfg, ... }:
    {
      programs.jujutsu = lib.mkIf cfg.inheritFromGit {
        inherit (myconfig.programs.git) settings wsl;
      };
    };
}
