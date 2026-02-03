{ delib, ... }:
delib.host {
  name = "spla-desktop-wsl";
  system = "x86_64-linux";

  nixos.system.stateVersion = "25.11";
  home.home.stateVersion = "25.11";

  nixos.wsl.enable = true;

  nixos.imports = [ ../../wsl-common ];
}
