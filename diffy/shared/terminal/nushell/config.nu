# command colors ($theme is injected from the catppuccin palette by default.nix)
$env.config.color_config.shape_internalcall = $theme.text
$env.config.color_config.shape_external_resolved = $theme.text
$env.config.color_config.shape_externalarg = $theme.lavender
$env.config.color_config.shape_flag = $theme.mauve

# stock nushell prompt, minus the right-side clock, path recolored lavender
$env.PROMPT_COMMAND_RIGHT = ""
let hostname = (sys host).hostname
$env.PROMPT_COMMAND = {||
    let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-dir }) {
        null => $env.PWD
        "" => "~"
        $relative => ([~ $relative] | path join)
    }
    let path_color = (ansi { fg: $theme.lavender attr: b })
    let separator_color = (ansi { fg: $theme.lavender })
    let host_segment = $"(ansi { fg: $theme.mauve attr: b })($hostname)(ansi reset) "
    let path_segment = $"($path_color)($dir)"
    $host_segment + ($path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)")
}

# green indicator, with a space between the path and the >
$env.PROMPT_INDICATOR = $"(char space)(ansi { fg: $theme.green attr: b })> (ansi reset)"

def adb-wifi [] {
    let services = avahi-browse --resolve --parsable --terminate _adb-tls-connect._tcp
        | lines
        | where ($it | str starts-with "=;")
        | split column ";" event interface protocol name type domain host address port
        | where protocol == IPv4
        # avahi can resolve an ipv4 advert to an ipv6 link-local address, which adb can't connect to
        | where not ($it.address | str contains ":")
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
