{
  delib,
  utils,
  host,
  ...
}:
let
  name = "ssh-agent-wsl";
  npiperelayExe = "/mnt/c/Users/songpola/AppData/Local/Microsoft/WinGet/Links/npiperelay.exe";
in
delib.module {
  # This module creates a systemd socket and service that delegates SSH agent to Windows via npiperelay (WSL only)
  name = "programs.ssh-agent-wsl";

  options = delib.singleEnableOption host.isWsl;

  nixos.ifEnabled = {
    environment.sessionVariables.SSH_AUTH_SOCK = "/run/${name}";

    systemd.sockets.${name} = {
      description = "SSH Agent socket relay to Windows via npiperelay";
      listenStreams = [ "%t/${name}" ]; # %t expands to /run/
      socketConfig.Accept = true;
      wantedBy = [ "sockets.target" ];
    };

    systemd.services."${name}@" = {
      description = "SSH Agent relay to Windows via npiperelay";
      serviceConfig = {
        ExecStart = "${npiperelayExe} ${
          utils.escapeSystemdExecArgs [
            "-v"
            "-p"
            "-ei"
            "-s"
            "//./pipe/openssh-ssh-agent"
          ]
        }";
        StandardInput = "socket";
        StandardOutput = "socket";
        StandardError = "journal";
      };
    };
  };
}
