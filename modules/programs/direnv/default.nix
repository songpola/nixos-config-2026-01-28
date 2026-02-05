{ delib, ... }:
delib.module {
  # The NixOS and Home Manager options won't conflict each other,
  # see ./README.md for more details.
  name = "programs.direnv";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    programs.direnv = {
      # nix-direnv is enabled by default
      enable = true;
      settings = {
        global = {
          warn_timeout = 0;
          hide_env_diff = true;
        };
      };
    };
  };

  home.ifEnabled = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
