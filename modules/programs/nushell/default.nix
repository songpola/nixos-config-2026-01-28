{
  delib,
  ...
}:
delib.module {
  name = "programs.nushell";

  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
    };
  };

  myconfig.ifEnabled = {
    programs.bash.autoExecNushell = true;
  };
}
