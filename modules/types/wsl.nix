{
  delib,
  inputs,
  pkgs,
  homeManagerUser,
  host,
  ...
}:
delib.module {
  name = "types.wsl";

  options = delib.singleEnableOption host.isWsl;

  nixos.always.imports = [ inputs.nixos-wsl.nixosModules.default ];

  nixos.ifEnabled = {
    wsl.enable = true;
    wsl.defaultUser = homeManagerUser;

    # Enable OpenGL driver from the Windows host
    # See https://github.com/nix-community/NixOS-WSL/blob/main/modules/wsl-distro.nix
    wsl.useWindowsDriver = true;

    # Enable USB/IP support for accessing USB devices from WSL
    wsl.usbip.enable = true;

    # See https://wiki.nixos.org/wiki/Serial_Console#Unprivileged_access_to_serial_device
    users.users.${homeManagerUser}.extraGroups = [ "dialout" ];

    # Enable xdg-open for opening files and URLs in WSL
    environment.systemPackages = [ pkgs.xdg-utils ];
  };

  myconfig.ifEnabled = {
    # I don't want to enter password every time I use sudo in WSL
    settings.wheelNoPassword.enable = true;
  };
}
