display_help() {
  echo "Usage: ephtools <command> [search paths...]"
  echo
  echo "Commands:"
  echo "  new   - List new files & directories that are not yet persisted"
  echo "  stray - List stray files & directories that are in persistent storage, but are not in the persistence config"
  echo
  echo "Arguments:"
  echo "  search paths - Override the search directories with one or more absolute paths"
}

SEARCH_DIRS=""

validate_directories() {
  local valid=true

  for path in "$@"; do
    if [ -d "$path" ]; then
      if [[ "$path" == /* ]]; then
        SEARCH_DIRS+="$path "
      else
        echo "Error: '$path' is not an absolute path"
        valid=false
      fi
    else
      echo "Error: '$path' is not a valid directory"
      valid=false
    fi
  done

  if [ "$valid" = false ]; then
    exit 1
  fi
}

if [ "$#" -lt 1 ]; then
  display_help
  exit 1
fi

COMMAND=$1
shift

case "$COMMAND" in
  "new")
    validate_directories "$@"
    if [ "$SEARCH_DIRS" = "" ]; then
      find / \( __NEW_EXCLUDE_OPTS__ \) -prune -o -type f -print
    else
      IFS=' ' read -r -a dir_array <<< "$SEARCH_DIRS"
      find "${dir_array[@]}" \( __NEW_EXCLUDE_OPTS__ \) -prune -o -type f -print
    fi
    ;;
  "stray")
    validate_directories "$@"
    if [ "$SEARCH_DIRS" = "" ]; then
      find __STRAY_CMD_SEARCH__ \( __STRAY_EXCLUDE_OPTS__ \) -prune -o \( -empty -type d -print \) -o \( -type f -print \)
    else
      IFS=' ' read -r -a dir_array <<< "$SEARCH_DIRS"
      find "${dir_array[@]}" \( __STRAY_EXCLUDE_OPTS__ \) -prune -o \( -empty -type d -print \) -o \( -type f -print \)
    fi
    ;;
  *)
    echo "Error: Unknown command"
    echo
    display_help
    exit 1
    ;;
esac