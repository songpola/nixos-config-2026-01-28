{ delib, pkgs, ... }:
delib.module {
  name = "programs.bat.batman";

  options = delib.singleCascadeEnableOption;

  home.ifEnabled = {
    # NOTE: Need to add batman using Home Manager options
    # to avoid shells integration in NixOS options.
    programs.bat.extraPackages = [ pkgs.bat-extras.batman ];
  };
}
