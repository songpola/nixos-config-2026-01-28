{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./ssh-agent-wsl
  ];

  wsl.enable = true;
  wsl.defaultUser = "songpola";

  # Default to private group instead of shared "users" group
  users.groups."songpola".gid = 1000;
  users.users."songpola".group = "songpola";
  users.users."songpola".extraGroups = [ "users" ];

  system.stateVersion = "25.11";

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
    ov
  ];

  environment.sessionVariables = {
    PAGER = "ov";
    # Let systemd use this pager
    SYSTEMD_PAGERSECURE = "false";
  };

  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
    "pipe-operators"
  ];

  nix.registry = {
    self.flake = inputs.self;
    unstable.to = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
  };

  # See Notes in README.md
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users."songpola" = {
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
    };

    programs.bash = {
      enable = true;
      initExtra = lib.mkOrder 3000 ''
        # Use nushell in place of bash unless FORCEBASH is set
        if [[ -z "$FORCEBASH" ]] && command -v nu >/dev/null 2>&1; then
          exec nu
        fi
      '';
    };

    programs.starship.enable = true;
    programs.zoxide.enable = true;
    programs.carapace.enable = true;
    programs.bat.enable = true;
    programs.eza.enable = true;

    programs.atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.ssh = {
      enable = true;

      enableDefaultConfig = false;
      matchBlocks."*" = {
        # Enable SSH connection multiplexing
        controlMaster = "auto";
        controlPersist = "10m";
        # Defaults from old `enableDefaultConfig` option
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlPath = "~/.ssh/master-%r@%n:%p";
      };
    };

    home.stateVersion = "25.11";
  };
}
