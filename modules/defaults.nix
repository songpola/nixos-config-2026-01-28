{
  delib,
  mySshPublicKey,
  pkgs,
  ...
}:
delib.module {
  # Note the 's' in "defaults"; it's just an arbitrary name.
  # Not to be confused with "default" in "default.nix".
  name = "defaults";

  options = delib.singleEnableOption true;

  myconfig.ifEnabled = {
    settings.vscodeRemoteSupport.enable = true;

    programs = {
      ssh.enable = true;
      ov.enable = true;
      micro.enable = true;
      nushell.enable = true;
      atuin.enable = true;
      eza.enable = true;
      fzf.enable = true;
      nh.enable = true;
      direnv.enable = true;
      starship.enable = true;
      carapace.enable = true;
      bat.enable = true;
      pay-respects.enable = true;
      zellij.enable = true;
      zoxide.enable = true;
      btop.enable = true;
      delta.enable = true;
    };

    programs.bash = {
      enable = true;
      autoExecNushell = true;
    };

    programs.git = {
      enable = true;
      settings = {
        user.name = "Songpol Anannetikul";
        user.email = "ice.songpola@pm.me";
      };
      wsl.commitSigning = {
        signerPath = "/mnt/c/Users/songpola/AppData/Local/Microsoft/WindowsApps/op-ssh-sign-wsl.exe";
        signingKey = mySshPublicKey;
      };
    };

    programs.jujutsu = {
      enable = true;
      inheritFromGit = true;
    };
  };

  nixos.ifEnabled = {
    environment.sessionVariables.EDITOR = "micro";

    environment.systemPackages = with pkgs; [
      just
      lsof
      ripgrep
      sops
      httpie
      fastfetch
      dust
      duf
      doggo
      ouch
      isd
      nix-output-monitor
      # Nix
      nil
      nixfmt-rfc-style
    ];
  };
}
