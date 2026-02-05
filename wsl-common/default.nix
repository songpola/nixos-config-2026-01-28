{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./ssh-agent-wsl
  ];

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
  };
}
