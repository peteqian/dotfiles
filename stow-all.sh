#!/usr/bin/env sh

set -eu

if ! command -v stow >/dev/null 2>&1; then
  echo "Error: GNU Stow is not installed or not in PATH." >&2
  exit 1
fi

SCRIPT_DIR=$(
  cd "$(dirname "$0")"
  pwd
)

OVERRIDE=false
if [ -t 0 ]; then
  printf "Override existing files when conflicts occur? [y/N]: "
  read -r answer
  case "$answer" in
    [yY]|[yY][eE][sS]) OVERRIDE=true ;;
  esac
else
  echo "Non-interactive shell detected; defaulting to no override."
fi

for dir in "$SCRIPT_DIR"/*/; do
  [ -d "$dir" ] || continue
  package=$(basename "$dir")
  echo "Stowing: $package -> $HOME"
  if [ "$OVERRIDE" = "true" ]; then
    stow --adopt --target "$HOME" --dir "$SCRIPT_DIR" "$package"
  else
    stow --target "$HOME" --dir "$SCRIPT_DIR" "$package"
  fi
done

echo "Done."
