{ delib, pkgs, ... }:
delib.module {
  name = "programs.delta";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = [ pkgs.delta ];
  };

  home.ifEnabled = {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
    };
  };
}
