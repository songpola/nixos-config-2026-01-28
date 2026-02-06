{ delib, host, ... }:
delib.module {
  # This module extends the module with WSL-specific options.
  # Such as, commit signing with SSH key via 1Password on Windows.
  name = "programs.jujutsu.wsl";

  options =
    with delib;
    moduleOptions {
      enable = boolOption host.isWsl;

      commitSigning = {
        signerPath = noDefault (strOption null);
        signingKey = noDefault (strOption null);
      };
    };

  home.ifEnabled =
    { cfg, ... }:
    {
      programs.jujutsu.settings.signing = {
        behavior = "own";
        backend = "ssh";
        backends.ssh.program = cfg.commitSigning.signerPath;
        key = cfg.commitSigning.signingKey;
      };
    };
}
