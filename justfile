repl:
    nix repl .

alias sw := switch
switch *ARGS:
    nh os switch . {{ARGS}}

alias a := add
add:
    git add .
