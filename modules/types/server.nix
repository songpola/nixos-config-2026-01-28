{
  delib,
  host,
  homeManagerUser,
  mySshPublicKey,
  ...
}:
delib.module {
  name = "types.server";

  options = delib.singleEnableOption host.isServer;

  myconfig.ifEnabled = {
    # Allow remote SSH login
    services.sshd.userAuthorizedKeys.${homeManagerUser} = [ mySshPublicKey ];

    # Auto-login on Linux console (getty)
    settings.consoleAutoLogin.enable = true;

    # Allow "wheel" group members to use `sudo` without password
    settings.wheelNoPassword.enable = true;
  };
}
