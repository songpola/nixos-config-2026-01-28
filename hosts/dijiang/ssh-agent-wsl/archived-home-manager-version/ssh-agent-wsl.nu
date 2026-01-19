use std/log

def main [] {
    if (which npiperelay.exe | is-empty) {
        log debug "npiperelay.exe not found, trying to install via winget.exe"
        if (which winget.exe | is-empty) {
            log error "winget.exe not found, cannot install npiperelay"
            log error ("PATH: " + ($env.PATH | str join (char newline)))
            exit 1
        } else {
            # https://github.com/albertony/npiperelay
            let result = winget.exe add -e albertony.npiperelay | complete
            # Nushell does not support redirecting stdout to stderr, so we have to log the result manually
            log debug $result.stdout
        }
    }
    let npiperelay = which npiperelay.exe | first | get path
    exec ...[ $npiperelay -v -p -ei -s //./pipe/openssh-ssh-agent ]
}
