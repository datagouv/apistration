#!/usr/bin/env bash
# Sonde un endpoint d'API : statut HTTP + corps joliment formaté.
# Ne jamais mettre le token en dur : le passer via $(cat .token) ou une variable.
#
# Usage:
#   probe_api.sh [--timeout SEC] [--show-headers] [--save-dir DIR] <URL> [HEADER ...] [-d <BODY>] [-X <METHOD>]
#
# Exemples:
#   probe_api.sh "https://api.exemple/v1/ressource/123" "X-API-Key: $(cat .token)"
#   probe_api.sh "https://api.exemple/v1/search" "X-API-Key: $(cat .token)" \
#     "Content-Type: application/json" -X POST -d '{"q":"foo"}'
#   probe_api.sh --show-headers --save-dir sandbox/api/demo/probes \
#     "https://api.exemple/v1/ressource/123" "Authorization: Bearer $(cat .token)"
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 [--timeout SEC] [--show-headers] [--save-dir DIR] <URL> [HEADER ...] [-d BODY] [-X METHOD]" >&2
  exit 2
fi

URL=""
ARGS=()
TIMEOUT="20"
SHOW_HEADERS=false
SAVE_DIR=""

while [ $# -gt 0 ]; do
  case "$1" in
    --timeout) TIMEOUT="$2"; shift 2 ;;
    --show-headers) SHOW_HEADERS=true; shift ;;
    --save-dir|--save) SAVE_DIR="$2"; shift 2 ;;
    -d) ARGS+=(--data "$2"); shift 2 ;;
    -X) ARGS+=(-X "$2"); shift 2 ;;
    *)
      if [ -z "$URL" ]; then
        URL="$1"
      else
        ARGS+=(-H "$1")
      fi
      shift
      ;;
  esac
done

if [ -z "$URL" ]; then
  echo "URL manquante" >&2
  exit 2
fi

BODY_FILE="$(mktemp)"
HEADERS_FILE="$(mktemp)"
trap 'rm -f "$BODY_FILE" "$HEADERS_FILE"' EXIT

set +e
META="$(curl -sS --max-time "$TIMEOUT" -D "$HEADERS_FILE" -o "$BODY_FILE" \
  -w '%{http_code} %{time_total} %{size_download} %{content_type}' \
  "${ARGS[@]}" "$URL")"
CURL_STATUS=$?
set -e

if [ "$CURL_STATUS" -ne 0 ]; then
  echo "curl a échoué (exit $CURL_STATUS) pour $URL" >&2
  exit "$CURL_STATUS"
fi

read -r CODE TIME_TOTAL SIZE_DOWNLOAD CONTENT_TYPE <<< "$META"

echo "HTTP $CODE  $URL"
echo "time=${TIME_TOTAL}s size=${SIZE_DOWNLOAD}B content_type=${CONTENT_TYPE:-unknown}"
echo "---"
if [ "$SHOW_HEADERS" = true ]; then
  sed -n '1,40p' "$HEADERS_FILE"
  echo "---"
fi
if command -v python3 >/dev/null && python3 -c "import json,sys; json.load(open('$BODY_FILE'))" 2>/dev/null; then
  python3 -m json.tool "$BODY_FILE"
else
  head -c 2000 "$BODY_FILE"; echo
fi

if [ -n "$SAVE_DIR" ]; then
  mkdir -p "$SAVE_DIR"
  STAMP="$(date +%Y%m%dT%H%M%S)"
  cp "$BODY_FILE" "$SAVE_DIR/${STAMP}_body.txt"
  cp "$HEADERS_FILE" "$SAVE_DIR/${STAMP}_headers.txt"
  {
    echo "url=$URL"
    echo "http_code=$CODE"
    echo "time_total=$TIME_TOTAL"
    echo "size_download=$SIZE_DOWNLOAD"
    echo "content_type=${CONTENT_TYPE:-unknown}"
  } > "$SAVE_DIR/${STAMP}_meta.txt"
  echo "---"
  echo "Sauvegardé dans $SAVE_DIR/${STAMP}_{body,headers,meta}.txt"
fi
