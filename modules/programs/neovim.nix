{ delib, ... }:
delib.module {
  name = "programs.neovim";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    programs.neovim.enable = true;
  };

  home.ifEnabled = {
    programs.neovim.enable = true;
  };
}
