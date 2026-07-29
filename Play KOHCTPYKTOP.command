#!/bin/zsh
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
WEB_DIR="$PROJECT_DIR/web"
PORT=8765
LOG_FILE="$(mktemp /tmp/kohctpyktop-web.XXXXXX.log)"

for required in "$WEB_DIR/kohctpyktop.swf" "$WEB_DIR/kohctpyktop.mp3" "$WEB_DIR/ruffle/ruffle.js"; do
  if [[ ! -f "$required" ]]; then
    echo "The playable files have not been installed yet."
    echo "Run ./scripts/setup.sh with your legitimate game files first."
    read -r "?Press Return to close."
    exit 1
  fi
done

if command -v lsof >/dev/null 2>&1 && lsof -nP -iTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "Local port $PORT is already in use. Close the program using it, then try again."
  read -r "?Press Return to close."
  exit 1
fi

cd "$WEB_DIR"
python3 -m http.server "$PORT" --bind 127.0.0.1 >"$LOG_FILE" 2>&1 &
SERVER_PID=$!

cleanup() {
  kill "$SERVER_PID" 2>/dev/null || true
  rm -f "$LOG_FILE"
}
trap cleanup EXIT INT TERM

sleep 1
if ! kill -0 "$SERVER_PID" 2>/dev/null; then
  echo "The local player could not start:"
  sed -n '1,20p' "$LOG_FILE"
  read -r "?Press Return to close."
  exit 1
fi

open "http://127.0.0.1:$PORT/"
echo "KOHCTPYKTOP is running at http://127.0.0.1:$PORT/"
echo "Keep this window open while playing. Press Control-C to stop."
wait "$SERVER_PID"
