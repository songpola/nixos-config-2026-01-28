{
  imports = [
    ./zfs.nix
  ];

  networking.hostName = "prts";
  system.stateVersion = "24.11";
  facter.reportPath = ./facter.json;
}
