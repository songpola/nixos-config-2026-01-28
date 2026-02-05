{ delib, lib, ... }:
delib.module {
  name = "programs.bash";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;

      autoExecNushell = boolOption false;
    };

  home.ifEnabled =
    { cfg, ... }:
    {
      programs.bash = {
        enable = true;

        # FIXME: Maybe login shell only?
        initExtra = lib.mkIf cfg.autoExecNushell (
          lib.mkOrder 3000 ''
            # Use Nushell in place of bash unless `FORCEBASH` is set
            if [[ -z "$FORCEBASH" ]] && command -v nu >/dev/null 2>&1; then
              exec nu
            fi
          ''
        );
      };
    };
}
