# command colors ($theme is injected from the catppuccin palette by default.nix)
$env.config.color_config.shape_internalcall = $theme.text
$env.config.color_config.shape_external_resolved = $theme.text
$env.config.color_config.shape_externalarg = $theme.lavender
$env.config.color_config.shape_flag = $theme.mauve

# stock nushell prompt, minus the right-side clock, path recolored mauve
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_COMMAND = {||
    let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-dir }) {
        null => $env.PWD
        "" => "~"
        $relative => ([~ $relative] | path join)
    }
    let path_color = (ansi { fg: $theme.mauve attr: b })
    let separator_color = (ansi { fg: $theme.mauve })
    let path_segment = $"($path_color)($dir)"
    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

# green indicator, with a space between the path and the >
$env.PROMPT_INDICATOR = $"(char space)(ansi { fg: $theme.green attr: b })> (ansi reset)"

def adb-wifi [] {
    let services = avahi-browse --resolve --parsable --terminate _adb-tls-connect._tcp
        | lines
        | where ($it | str starts-with "=;")
        | split column ";" event interface protocol name type domain host address port
        | where protocol == IPv4
    if ($services | is-empty) { error make { msg: "no phone with wireless debugging found" } }
    let service = $services | first
    adb connect $"($service.address):($service.port)"
}

# carapace returns [] for positions it can't complete which suppresses nushell's file fallback
# convert empty results to null so nushell completes files instead
# fixes ffmpeg -i completion
let carapace_completer = $env.config.completions.external.completer
$env.config.completions.external.completer = {|spans|
    let result = (try { do $carapace_completer $spans } catch { null })
    if ($result | is-empty) { null } else { $result }
}
