{ delib, ... }:
delib.module {
  # Note the 's' in "defaults"; it's just an arbitrary name.
  # Not to be confused with "default" in "default.nix".
  name = "defaults";

  options = delib.singleEnableOption true;

  myconfig.ifEnabled = {
    programs = {
      ssh.enable = true;
      ov.enable = true;
      vscodeRemote.enable = true;
      micro.enable = true;
      nushell.enable = true;
      atuin.enable = true;
      eza.enable = true;
      fzf.enable = true;
      nh.enable = true;
      direnv.enable = true;
    };
  };
}
