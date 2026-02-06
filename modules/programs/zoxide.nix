{ delib, ... }:
delib.module {
  name = "programs.zoxide";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    programs.zoxide.enable = true;
  };

  home.ifEnabled = {
    programs.zoxide.enable = true;
  };
}
