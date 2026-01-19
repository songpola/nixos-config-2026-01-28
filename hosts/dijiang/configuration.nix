{
  pkgs,
  ...
}:
{
  wsl.enable = true;
  wsl.defaultUser = "songpola";

  system.stateVersion = "25.11";

  networking.hostName = "SPLA-DIJIANG";

  environment.systemPackages = with pkgs; [
    micro
    nh
    git
    jujutsu
    just
    wget
    nil
    direnv
    nushell
    nix-output-monitor
    isd
  ];

  programs.nix-ld.enable = true;

  nix.settings = {
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
  };

  # See Notes in README.md
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
