{
  delib,
  inputs,
  pkgs,
  homeManagerUser,
  ...
}:
delib.module {
  name = "types.wsl";

  options = delib.singleEnableOption false;

  nixos.always.imports = [ inputs.nixos-wsl.nixosModules.default ];

  nixos.ifEnabled = {
    wsl.enable = true;
    wsl.defaultUser = homeManagerUser;

    # Enable xdg-open for opening files and URLs in WSL
    environment.systemPackages = [ pkgs.xdg-utils ];
  };

  myconfig.ifEnabled = {
    # I don't want to enter password every time I use sudo in WSL
    settings.wheelNoPassword.enable = true;
  };
}
