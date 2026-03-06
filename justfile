alias c := check
alias sw := switch
alias bt := boot
alias a := add

repl *ARGS:
    nix repl . {{ ARGS }}

check *ARGS:
    nix flake check . {{ ARGS }}

switch *ARGS:
    nh os switch . {{ ARGS }}

boot *ARGS:
    nh os boot . {{ ARGS }}

add:
    git add .

update:
    nix flake update

rm-channels-leftover:
    sudo rm -r /root/.nix-defexpr/channels /nix/var/nix/profiles/per-user/root/channels
