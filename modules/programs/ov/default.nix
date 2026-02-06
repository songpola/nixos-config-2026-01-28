{
  delib,
  pkgs,
  lib,
  myconfig,
  ...
}:
delib.module {
  name = "programs.ov";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;

      configFilePath = allowNull (pathOption ./config.yaml);

      enableDeltaIntegration = boolOption myconfig.programs.delta.enable;
      enableBatIntegration = boolOption myconfig.programs.bat.enable;
      enableBatmanIntegration = boolOption myconfig.programs.bat.batman.enable;
    };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      environment.systemPackages = [ pkgs.ov ];

      environment.sessionVariables = {
        PAGER = "ov";
        SYSTEMD_PAGERSECURE = "false"; # Let systemd use this pager

        # -F, --quit-if-one-screen: Quit if one screen
        # NOTE: No need to use `--raw` option; ov can handle the escape sequences
        DELTA_PAGER = lib.mkIf cfg.enableDeltaIntegration "ov -F";

        # -F, --quit-if-one-screen: Quit if one screen
        # -H3, --header-lines=3: Display 3 fixed lines as header
        # -X, --exit-write: Output on exit
        #
        # NOTE: Delta pager *might* use this environment variable too
        #       if `DELTA_PAGER` env var is not set.
        BAT_PAGER = lib.mkIf cfg.enableBatIntegration "ov -F -H3 -X";

        # For `batman` command
        MANPAGER = lib.mkIf cfg.enableBatmanIntegration "ov --section-delimiter '^[^\\s]'";
      };
    };

  home.ifEnabled =
    { cfg, ... }:
    {
      xdg.configFile."ov/config.yaml".source = cfg.configFilePath;

      # Ensure that bat does not wrap lines (--wrap=never).
      # If bat wraps lines, it cannot be unwrapped later.
      # It is recommended to use ov for better operation.
      programs.bat.config.wrap = lib.mkIf cfg.enableBatIntegration "never";
    };
}
