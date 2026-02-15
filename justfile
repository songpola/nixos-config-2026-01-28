repl *ARGS:
    nix repl . {{ ARGS }}

alias c := check

check *ARGS:
    nix flake check . {{ ARGS }}

alias sw := switch

switch *ARGS:
    nh os switch . {{ ARGS }}

alias bt := boot

boot *ARGS:
    nh os boot . {{ ARGS }}

alias a := add

add:
    git add .

rm-channels-leftover:
    sudo rm -r /root/.nix-defexpr/channels /nix/var/nix/profiles/per-user/root/channels
