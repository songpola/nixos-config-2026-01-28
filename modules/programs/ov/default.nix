{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ov";

  options =
    with delib;
    moduleOptions {
      enable = boolOption true;

      configFilePath = allowNull (pathOption ./config.yaml);
    };

  nixos.ifEnabled = {
    environment.systemPackages = [ pkgs.ov ];

    environment.sessionVariables = {
      PAGER = "ov";
      SYSTEMD_PAGERSECURE = "false"; # Let systemd use this pager
    };

  };

  home.ifEnabled =
    { cfg, ... }:
    {
      xdg.configFile."ov/config.yaml".source = cfg.configFilePath;
    };
}
