{
  delib,
  ...
}:
delib.module {
  name = "programs.comma";

  options = delib.singleEnableOption false;

  myconfig.ifEnabled = {
    programs.nix-index-database.enable = true;
  };

  nixos.ifEnabled = {
    programs.nix-index-database.comma.enable = true;
  };

  home.ifEnabled = {
    programs.nix-index-database.comma.enable = true;
  };
}
