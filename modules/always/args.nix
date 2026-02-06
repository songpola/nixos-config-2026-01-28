{
  delib,
  lib,
  homeManagerUser,
  ...
}:
delib.module {
  name = "always.args";

  myconfig.always =
    { myconfig, ... }:
    {
      args.shared = {
        inherit myconfig;
        inherit (myconfig) homeconfig;

        mySshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMSjfctCxjS+/jDcVERwcTN6wP+GaScfSo4VtfsmagOz songpola";
        prtsHostName = "prts.tail7623c.ts.net";
        prtsHostSshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBD1r/jrkJbCXK7p6RNd4+fyCcxYCl7tdPwIGaWLhjzq";
      };
    };

  # Alias: `myconfig.homeconfig` -> `home-manager.users.<username>`
  nixos.always.imports = [
    (lib.mkAliasOptionModule [ "myconfig" "homeconfig" ] [ "home-manager" "users" homeManagerUser ])
  ];
}
