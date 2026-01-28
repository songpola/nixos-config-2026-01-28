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

alias eza = eza --group --group-directories-first --time-style=relative
alias ls = eza
alias la = eza -aa
alias ll = eza -l
alias lla = eza -laa
alias llt = ll --tree
alias llta = llt -a # Option --tree is useless given --all --all

alias sw = nh os switch
alias swn = nh os switch -n
alias bt = nh os boot

alias bm = batman

alias gs = git status
alias ga = git add .

alias gcm = bunx -b czg emoji gpg

alias j = just

alias jl = jj log
alias jlr = jj log -r
alias jla = jj log -r ::
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
alias jmm = jj bookmark move main -t @- # move main bookmark to last revision
alias jab = jj abandon
alias jun = jj undo
alias jfa = jj file annotate
alias jfu = jj file untrack
alias ji = jj git init
alias jf = jj git fetch
alias jp = jj git push
alias jrl = jj git remote list
alias jra = jj git remote add
alias jrs = jj git remote set-url
alias jgc = jj git clone

alias p = podman

alias h = ^http # HTTPie http
alias hs = ^https # HTTPie https

alias ze = zellij

alias da = direnv allow

alias skr = ssh-keygen -R
