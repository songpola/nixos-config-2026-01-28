{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.micro";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    environment.systemPackages = [ pkgs.micro ];
  };

  home.ifEnabled = {
    programs.micro = {
      enable = true;
      settings.clipboard = "terminal";
    };
  };
}
