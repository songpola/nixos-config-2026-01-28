{ delib, ... }:
delib.module {
  name = "programs.git";

  options =
    with delib;
    moduleOptions {
      settings = {
        user.name = allowNull (strOption null);
        user.email = allowNull (strOption null);
      };
    };

  home.ifEnabled =
    { cfg, ... }:
    {
      programs.git.settings = cfg.settings // {
        init.defaultBranch = "main";
        merge.conflictstyle = "zdiff3";
      };
    };
}
