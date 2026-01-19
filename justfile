repl:
    nix repl .

alias sw := switch
switch *ARGS:
    nh os switch . {{ARGS}}

add:
    git add .
