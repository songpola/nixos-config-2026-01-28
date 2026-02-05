{
  delib,
  ...
}:
delib.module {
  name = "programs.ssh";

  options = delib.singleEnableOption false;

  home.ifEnabled = {
    programs.ssh = {
      enable = true;

      # TODO: Remove this line in the future when deprecated
      enableDefaultConfig = false;

      matchBlocks."*" = {
        # Enable SSH connection multiplexing
        controlMaster = "auto";
        controlPersist = "10m";
        controlPath = "~/.ssh/master-%r@%n:%p";

        # # These used to be the defaults from the `enableDefaultConfig` option
        # # Enable as needed.
        # forwardAgent = false;
        # addKeysToAgent = "no";
        # compression = false;
        # serverAliveInterval = 0;
        # serverAliveCountMax = 3;
        # hashKnownHosts = false;
        # userKnownHostsFile = "~/.ssh/known_hosts";
      };
    };
  };
}
