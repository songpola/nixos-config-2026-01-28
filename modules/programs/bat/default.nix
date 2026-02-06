{ delib, ... }:
delib.module {
  name = "programs.bat";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    programs.bat.enable = true;
  };

  home.ifEnabled = {
    programs.bat.enable = true;
  };
}
