# check if command is "os" and second argument is one of switch/boot/test/build
if [[ -n "${1+x}" ]] && [[ "$1" == "os" ]] && [[ -n "${2+x}" ]] && [[ "$2" =~ ^(switch|boot|test|build)$ ]]; then
  # check if any remaining argument is -u or --update
  for arg in "${@:3}"; do
    if [[ "$arg" == "-u" || "$arg" == "--update" ]]; then
      if [[ -d "$NH_FLAKE/pkgs" ]]; then
        echo -e "\e[32m>\e[0m Updating package sources"
        cd "$NH_FLAKE/pkgs"
        nvfetcher
      else
        echo "Directory $NH_FLAKE/pkgs does not exist." >&2
        exit 1
      fi
      break
    fi
  done
fi

# Pass through to real nh
command nh "$@"