{ delib, ... }:
delib.module {
  name = "programs.pay-respects";

  options = delib.singleEnableOption false;

  # Enable on Home Manger option only, to avoid conflicts with NixOS module
  home.ifEnabled = {
    programs.pay-respects.enable = true;
  };
}
