{ delib, ... }:
delib.module {
  name = "programs.nh";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;

      autoCleanAllWeekly = boolOption false;
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      programs.nh = {
        enable = true;

        # Auto clean (all) (default: weekly)
        # NOTE: No need to use the options from Home Manager,
        # because all the profiles (both system and user) will be cleaned by this options.
        clean.enable = cfg.autoCleanAllWeekly;
      };
    };
}
