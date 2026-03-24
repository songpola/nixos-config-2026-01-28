{
  delib,
  mySshPublicKey,
  pkgs,
  myconfig,
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

    environment.systemPackages =
      with pkgs;
      [
        just
        just-lsp
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
        jq
        # Nix
        nil
        nixfmt-rfc-style
        dix
      ]
      ++ lib.optionals (myconfig.virtualization.docker.enable || myconfig.virtualization.podman.enable) [
        pkgs.unstable.dtop # not available in 25.11 yet
      ]
      ++ lib.optionals (myconfig.virtualization.podman.enable) [
        podman-tui
      ];
  };
}
