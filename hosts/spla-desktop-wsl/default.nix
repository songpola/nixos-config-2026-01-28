{
  delib,
  pkgs,
  ...
}:
delib.host {
  name = "spla-desktop-wsl";
  system = "x86_64-linux";
  type = "wsl";

  nixos.system.stateVersion = "25.11";
  home.home.stateVersion = "25.11";

  # nixos.nixpkgs.overlays = [
  #   (final: prev: {
  #     mesa = pkgs.unstable.mesa;
  #   })
  # ];

  nixos.environment.systemPackages = with pkgs; [
    github-copilot-cli
  ];

  myconfig.programs.pixi.enable = true;

  myconfig.programs.comma.enable = true;
}
