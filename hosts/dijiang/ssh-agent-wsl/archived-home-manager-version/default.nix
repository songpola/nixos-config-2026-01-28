# Home Manager version of ssh-agent-wsl service implementation
# This only serves as a reference.
# Don't use this version; use the system-wide one instead.
#
# Reasons:
# - This version attempts to detect if `npiperelay.exe` is installed. If not,
#   it tries to install it using `winget`. However, this complicates the setup
#   and requires setting the Environment PATH in the systemd service. The
#   system-wide version assumes `npiperelay.exe` is already installed and
#   available in PATH, which is simpler and more robust. The user can simply
#   install `npiperelay.exe` manually using `winget` or other means.
# - This version requires Nushell as a dependency for its script. The system-wide
#   version executes `npiperelay.exe` directly, which is simpler.
# - The `ExecStart` command need `utils` from NixOS modules, which needs to be
#   provided when importing. The system-wide version can just use it directly.
# - This version sets `SSH_AUTH_SOCK` in `home.sessionVariables`. This requires
#   user shells (such as Bash) to be managed by Home Manager to work correctly.
#   The system-wide version sets `SSH_AUTH_SOCK` globally instead.
utils:
{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  socketName = "ssh-agent-wsl.socket";
in
{
  programs.bash.enable = true; # Ensure the home.sessionVariables are loaded in bash
  home.sessionVariables.SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}" + socketName; # $XDG_RUNTIME_DIR has trailing slash

  systemd.user.sockets."ssh-agent-wsl" = {
    Unit.Description = "SSH Agent socket relay to Windows via npiperelay";
    Socket = {
      ListenStream = "%t/${socketName}";
      Accept = true;
    };
    Install.WantedBy = [ "sockets.target" ];
  };

  systemd.user.services."ssh-agent-wsl@" = {
    Unit.Description = "SSH Agent relay to Windows via npiperelay";
    Service = {
      Environment =
        "PATH="
        + lib.concatStringsSep ":" [
          "/mnt/c/Users/songpola/AppData/Local/Microsoft/WindowsApps"
          "/mnt/c/Users/songpola/AppData/Local/Microsoft/WinGet/Links"
        ];
      ExecStart = "${lib.getExe pkgs.nushell} ${
        utils.escapeSystemdExecArgs [
          "--stdin"
          ./ssh-agent-wsl.nu
        ]
      }";
      StandardInput = "socket";
      StandardOutput = "socket";
      StandardError = "journal";
    };
  };
}
