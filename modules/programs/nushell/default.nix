{
  delib,
  lib,
  ...
}:
delib.module {
  name = "programs.nushell";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;

      autoExecFromBash = boolOption false;
    };

  home.ifEnabled =
    { cfg, ... }:
    {
      programs.nushell = {
        enable = true;
        configFile.source = ./config.nu;
      };

      programs.bash = {
        enable = true;
        initExtra = lib.mkIf cfg.autoExecFromBash (
          lib.mkOrder 3000 ''
            # Check if we're in a login shell and if nushell is available, then exec it.
            if shopt -q login_shell && command -v nu >/dev/null 2>&1; then
              exec nu
            fi
          ''
        );
      };
    };
}
