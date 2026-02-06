{ delib, ... }:
delib.module {
  name = "programs.jujutsu";

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
      programs.jujutsu.settings = cfg.settings // {
        ui = {
          # Use Git's "diff3" style conflict markers
          conflict-marker-style = "git";

          # This only works if jj is called from VS Code's terminal
          merge-editor = "vscode";

          # TODO: maybe change to `vscode` when it's supported
          diff-editor = ":builtin";
        };
      };
    };
}
