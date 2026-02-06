{ delib, ... }:
delib.module {
  name = "programs.carapace";

  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.carapace.enable = true;
  };
}
