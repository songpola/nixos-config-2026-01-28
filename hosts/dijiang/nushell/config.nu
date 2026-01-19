use std/util "path add"

$env.config.show_banner = false

# If the terminal is VS Code terminal, use code as the default editor
if ($env.TERM_PROGRAM? == "vscode") {
    $env.config.buffer_editor = ["code", "--wait"]
    $env.VISUAL = $env.config.buffer_editor | str join ' '
    $env.EDITOR = $env.VISUAL
}

# Shortcut for nom/nix shell
def shell [
    ...pkgs
    --flake (-f) = "nixpkgs"
    --dry (-n)
] {
    let pkgs = ($pkgs | default -e [ "default" ]) | each { |pkg| $flake + "#" + $pkg }
    # If `nom` (nix-output-monitor) is available, use it instead of `nix shell`
    let cmd = if (which nom | is-not-empty) {
        [ nom shell ...$pkgs ]
    } else {
        [ nix shell ...$pkgs ]
    }
    if $dry {
        print $cmd
    } else {
        run-external $cmd
    }
}

alias c = clear
alias l = ls

alias sw = nh os switch
alias swn = nh os switch -n
alias bt = nh os boot

alias bm = batman

alias ga = git add .
alias gp = git push

alias gcm = bunx -b czg emoji gpg

alias j = just

alias jl = jj log
alias je = jj edit
alias jc = jj commit
alias jd = jj desc
alias jdf = jj diff
alias js = jj split
alias jsh = jj show
alias jsq = jj squash
alias jst = jj status
alias jr = jj rebase
alias jn = jj new
alias jnm = jj new main
alias jb = jj bookmark
alias jm = jj bookmark move
alias jmm = jj bookmark move main -t @- # move main to last commit
alias jf = jj git fetch
alias jp = jj git push

alias p = podman

# HTTPie
alias h = ^http
alias hs = ^https

alias ze = zellij
