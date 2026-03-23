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

remote OP HOSTNAME TARGET *ARGS:
    nh os {{ OP }} . --hostname={{ HOSTNAME }} --target-host={{ TARGET }} --elevation-strategy=passwordless {{ ARGS }}

boot *ARGS:
    nh os boot . {{ ARGS }}

build *ARGS:
    nh os build . {{ ARGS }}

add:
    git add .

update:
    nix flake update

cleanup-channels:
    sudo rm -r /root/.nix-defexpr/channels /nix/var/nix/profiles/per-user/root/channels

sops-new PATH *ARGS:
    sops {{ PATH }} {{ ARGS }}

sops-edit PATH *ARGS:
    sops edit {{ PATH }} {{ ARGS }}
