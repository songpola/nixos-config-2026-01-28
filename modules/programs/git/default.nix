{ delib, ... }:
delib.module {
  name = "programs.git";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    programs.git.enable = true;
  };

  home.ifEnabled = {
    programs.git.enable = true;
  };
}
