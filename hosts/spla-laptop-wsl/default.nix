{ delib, pkgs, ... }:
delib.host {
  name = "spla-laptop-wsl";
  system = "x86_64-linux";
  type = "wsl";

  nixos.system.stateVersion = "25.11";
  home.home.stateVersion = "25.11";

  nixos.environment.systemPackages = with pkgs; [
    github-copilot-cli
  ];
}
