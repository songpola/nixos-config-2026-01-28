{ delib, ... }:
delib.module {
  # This module sets to no password required for wheel group when using sudo or polkit
  name = "wheelNoPassword";

  options = delib.singleEnableOption false;

  nixos.ifEnabled = {
    security = {
      sudo.wheelNeedsPassword = false;

      # Allow members of the "wheel" group to manage system services without password
      # Credit: https://wiki.nixos.org/wiki/Polkit#No_password_for_wheel
      polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.isInGroup("wheel"))
            return polkit.Result.YES;
        });
      '';
    };
  };
}
