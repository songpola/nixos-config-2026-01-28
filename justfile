repl:
    nix repl .

alias sw := switch
switch *ARGS:
    nh os switch . {{ARGS}}

alias bt := boot
boot *ARGS:
    nh os boot . {{ARGS}}

alias a := add
add:
    git add .
