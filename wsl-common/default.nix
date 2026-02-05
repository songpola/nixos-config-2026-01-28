{
  pkgs,
  ...
}:
{
  imports = [
    ./ssh-agent-wsl
  ];

  environment.systemPackages = with pkgs; [
    git
    just
    wget
    nil
    direnv
    nix-output-monitor
    isd
  ];

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

    programs.starship.enable = true;
    programs.zoxide.enable = true;
    programs.carapace.enable = true;
    programs.bat.enable = true;
  };
}
