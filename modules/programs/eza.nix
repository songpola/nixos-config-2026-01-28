{ delib, ... }:
delib.module {
  name = "programs.eza";

  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.eza = {
      enable = true;
      enableNushellIntegration = false; # Use custom aliases instead
    };
  };
}
