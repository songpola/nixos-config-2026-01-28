{ delib, ... }:
delib.host {
  name = "spla-desktop-wsl";
  system = "x86_64-linux";

  nixos.system.stateVersion = "25.11";
  home.home.stateVersion = "25.11";

  myconfig.types.wsl.enable = true;

  myconfig.defaults.enable = true;
}
