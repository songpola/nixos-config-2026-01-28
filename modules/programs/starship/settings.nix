{ lib, ... }:
{
  myconfig.programs.starship = {
    presets = [
      "catppuccin-powerline"
      "nerd-font-symbols"
    ];
    settings = {
      # Enable line breaks for two-line prompts.
      # `disabled = true` by default from catppuccin-powerline preset.
      line_break.disabled = false;
      os.disabled = false;
      shell.disabled = false;
      username.format = "[ $user@]($style)";
      hostname = {
        ssh_only = false;
        ssh_symbol = " ";
        style = "bg:red fg:crust";
        format = "[$hostname$ssh_symbol ]($style)";
      };
      # Add $shell to the prompt
      format =
        ''
          [](red)
          $os
          $username
          $hostname
          [](bg:peach fg:red)
          $directory
          [](bg:yellow fg:peach)
          $git_branch
          $git_status
          [](fg:yellow bg:green)
          $c
          $rust
          $golang
          $nodejs
          $php
          $java
          $kotlin
          $haskell
          $python
          [](fg:green bg:sapphire)
          $conda
          [](fg:sapphire bg:lavender)
          $time
          [ ](fg:lavender)
          $cmd_duration
          $line_break
          $shell
          $character
        ''
        |> lib.replaceString "\n" ""; # remove newlines
    };
  };
}
