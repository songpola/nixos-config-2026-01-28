{
  delib,
  pkgs,
  lib,
  homeconfig,
  ...
}:
delib.module {
  name = "programs.starship";

  options =
    with delib;
    moduleOptions {
      enable = boolOption false;

      presets = listOfOption str [ ];

      settings = attrsOption { };
    };

  # NOTE: Use custom starship integration implementation.
  # The NixOS options don't have Nushell integration.
  home.ifEnabled =
    { cfg, ... }:
    let
      tomlFormat = pkgs.formats.toml { };
      settingsFile = tomlFormat.generate "starship.toml" cfg.settings;

      presetMergedSettingsFile =
        if cfg.presets == [ ] then
          settingsFile
        else
          pkgs.runCommand "starship.toml"
            {
              nativeBuildInputs = [ pkgs.yq ];
            }
            ''
              tomlq -s -t 'reduce .[] as $item ({}; . * $item)' \
                ${
                  lib.concatStringsSep " " (
                    cfg.presets |> map (preset: "${pkgs.starship}/share/starship/presets/${preset}.toml")
                  )
                } \
                ${settingsFile} \
                > $out
            '';

      configPath = "${homeconfig.xdg.configHome}/starship.toml";
    in
    {
      home = {
        packages = [ pkgs.starship ];

        file.${configPath} = lib.mkIf (cfg.settings != { }) {
          source = presetMergedSettingsFile;
        };

        sessionVariables.STARSHIP_CONFIG = configPath;
      };

      programs.bash.initExtra = ''
        if [[ $TERM != "dumb" && $TERM != "linux" ]]; then
          eval "$(${lib.getExe pkgs.starship} init bash --print-full-init)"
        fi
      '';

      programs.nushell.extraConfig = (
        let
          starshipInitNu = pkgs.runCommand "starship-nushell-config.nu" { } ''
            ${lib.getExe pkgs.starship} init nu >> $out
          '';
        in
        ''
          if ($env.TERM != "dumb" and $env.TERM != "linux") {
              source ${starshipInitNu}
          }
        ''
      );
    };
}
