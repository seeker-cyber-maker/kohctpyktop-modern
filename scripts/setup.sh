#!/bin/sh
set -eu

RUFFLE_VERSION="0.4.1"
RUFFLE_SHA256="d33c135beea75c83183da1938a49ee3f08c2f7a2eb2ae8f3ce43de842412aae6"
SWF_SHA256="66a80330f3be9570b72f4bc2057a1b65b573e8c874f296099457e73c90e99356"
MP3_SHA256="cf4b6769023dded3fb336cb633ade0bc6309a591578d5a3929d779f02efba5b2"

ROOT_DIR=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
WEB_DIR="$ROOT_DIR/web"
DEFAULT_STEAM_DIR="$HOME/Library/Application Support/Steam/steamapps/common/ZACH-LIKE/games/kohctpyktop"
SWF_SOURCE=${1:-"$DEFAULT_STEAM_DIR/kohctpyktop.swf"}
MP3_SOURCE=${2:-"$DEFAULT_STEAM_DIR/kohctpyktop.mp3"}

usage() {
  echo "Usage: $0 [/path/to/kohctpyktop.swf] [/path/to/kohctpyktop.mp3]"
  echo "Without arguments, the script checks the default macOS Steam ZACH-LIKE location."
}

if [ ! -f "$SWF_SOURCE" ] || [ ! -f "$MP3_SOURCE" ]; then
  usage
  echo
  echo "Could not find both legitimate game assets."
  exit 1
fi

sha256_file() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  elif command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    echo "A SHA-256 utility is required." >&2
    exit 1
  fi
}

verify() {
  actual=$(sha256_file "$1")
  expected=$2
  label=$3
  if [ "$actual" != "$expected" ]; then
    echo "$label did not match the validated archival release." >&2
    echo "Expected: $expected" >&2
    echo "Actual:   $actual" >&2
    exit 1
  fi
  echo "Verified $label"
}

verify "$SWF_SOURCE" "$SWF_SHA256" "KOHCTPYKTOP SWF"
verify "$MP3_SOURCE" "$MP3_SHA256" "KOHCTPYKTOP music"

TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/kohctpyktop-setup.XXXXXX")
STAGED_RUFFLE="$WEB_DIR/.ruffle-staged.$$"
PREVIOUS_RUFFLE="$WEB_DIR/.ruffle-previous.$$"
cleanup() {
  rm -rf "$TEMP_DIR" "$STAGED_RUFFLE"
  if [ -d "$PREVIOUS_RUFFLE" ] && [ ! -d "$WEB_DIR/ruffle" ]; then
    mv "$PREVIOUS_RUFFLE" "$WEB_DIR/ruffle"
  else
    rm -rf "$PREVIOUS_RUFFLE"
  fi
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM
RUFFLE_ZIP="$TEMP_DIR/ruffle-web.zip"
RUFFLE_URL="https://github.com/ruffle-rs/ruffle/releases/download/v$RUFFLE_VERSION/ruffle-$RUFFLE_VERSION-web-selfhosted.zip"

echo "Downloading the official Ruffle $RUFFLE_VERSION web runtime..."
curl -fL "$RUFFLE_URL" -o "$RUFFLE_ZIP"
verify "$RUFFLE_ZIP" "$RUFFLE_SHA256" "Ruffle web runtime"

mkdir -p "$WEB_DIR" "$STAGED_RUFFLE"
unzip -q "$RUFFLE_ZIP" -d "$STAGED_RUFFLE"
if [ ! -f "$STAGED_RUFFLE/ruffle.js" ]; then
  echo "The verified Ruffle archive did not contain ruffle.js." >&2
  exit 1
fi

if [ -d "$WEB_DIR/ruffle" ]; then
  mv "$WEB_DIR/ruffle" "$PREVIOUS_RUFFLE"
fi
mv "$STAGED_RUFFLE" "$WEB_DIR/ruffle"
rm -rf "$PREVIOUS_RUFFLE"
cp "$SWF_SOURCE" "$WEB_DIR/kohctpyktop.swf"
cp "$MP3_SOURCE" "$WEB_DIR/kohctpyktop.mp3"

echo
echo "Installation complete. Double-click Play KOHCTPYKTOP.command."
