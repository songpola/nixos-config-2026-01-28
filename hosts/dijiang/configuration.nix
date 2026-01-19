{
  pkgs,
  inputs,
  ...
}:
{
  wsl.enable = true;
  wsl.defaultUser = "songpola";

  system.stateVersion = "25.11";

  networking.hostName = "dijiang";

  environment.systemPackages = with pkgs; [
    micro
    nh
    git
    just
    wget
    nil
    direnv
    nix-output-monitor
    isd
  ];

  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
    "pipe-operators"
  ];

  nix.registry.self.flake = inputs.self;
  nix.registry.unstable.to = {
    type = "github";
    owner = "NixOS";
    repo = "nixpkgs";
    ref = "nixos-unstable";
  };

  # See Notes in README.md
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.songpola = {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          email = "ice.songpola@pm.me";
          name = "Songpol Anannetikul";
        };

        # Use Git's "diff3" style conflict markers
        ui.conflict-marker-style = "git";
      };
    };

    programs.nushell = {
      enable = true;
      configFile.source = ./nushell/config.nu;
      shellAliases = {
        llt = "eza -l --tree";
      };
    };

    programs.starship.enable = true;
    programs.zoxide.enable = true;
    programs.carapace.enable = true;
    programs.atuin.enable = true;

    programs.eza = {
      enable = true;
      extraOptions = [
        "-g" # list each file's group
        "--group-directories-first"
      ];
      enableNushellIntegration = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home.stateVersion = "25.11";
  };
}
