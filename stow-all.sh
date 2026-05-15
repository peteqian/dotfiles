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

OS=$(uname -s)
SKIP_PACKAGES=""
WINDOWS_SKIP_PACKAGES="aerospace hypr hypridle hyprland hyprlock hyprmocha hyprpaper waybar wofi"

case "$OS" in
  Darwin)
    SKIP_PACKAGES="hypr hypridle hyprland hyprlock hyprmocha hyprpaper waybar wofi"
    ;;
  Linux)
    SKIP_PACKAGES="aerospace"
    ;;
  MINGW*|MSYS*|CYGWIN*|*)
    SKIP_PACKAGES=$WINDOWS_SKIP_PACKAGES
    ;;
esac

has_command() {
  command -v "$1" >/dev/null 2>&1
}

package_is_skipped() {
  package=$1

  for skipped_package in $SKIP_PACKAGES; do
    if [ "$package" = "$skipped_package" ]; then
      return 0
    fi
  done

  return 1
}

should_stow_package() {
  package=$1

  if package_is_skipped "$package"; then
    echo "Skipping package for $OS: $package"
    return 1
  fi

  case "$package" in
    hypridle|hyprland|hyprlock|hyprmocha|hyprpaper)
      if [ -d "$SCRIPT_DIR/hypr" ]; then
        echo "Skipping legacy Hypr package: $package"
        return 1
      fi
      ;;
  esac

  case "$package" in
    hypr)
      if has_command Hyprland || has_command hyprctl; then
        return 0
      fi

      echo "Skipping Hyprland package: $package"
      return 1
      ;;
    waybar)
      if has_command waybar; then
        return 0
      fi

      echo "Skipping Waybar package: $package"
      return 1
      ;;
    wofi)
      if has_command wofi; then
        return 0
      fi

      echo "Skipping Wofi package: $package"
      return 1
      ;;
  esac

  return 0
}

stow_package() {
  package=$1

  should_stow_package "$package" || return 0

  echo "Stowing: $package -> $HOME"
  if [ "$OVERRIDE" = "true" ]; then
    stow --adopt --target "$HOME" --dir "$SCRIPT_DIR" "$package"
  else
    stow --target "$HOME" --dir "$SCRIPT_DIR" "$package"
  fi
}

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

if [ -d "$SCRIPT_DIR/omp" ]; then
  stow_package omp
fi

for dir in "$SCRIPT_DIR"/*/; do
  [ -d "$dir" ] || continue
  package=$(basename "$dir")

  if [ "$package" = "omp" ]; then
    continue
  fi

  stow_package "$package"
done

echo "Done."
