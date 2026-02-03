{
  delib,
  homeManagerUser,
  ...
}:
delib.module {
  # This module enables autologin for the specified user on Linux console.
  # This is typically used for server (or VM) hosts with console access.
  name = "consoleAutoLogin";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    services.getty.autologinUser = homeManagerUser;
  };
}
