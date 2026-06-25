#!/usr/bin/env bash
set -euo pipefail

# Échantillonnage d'une API fournisseur sur une liste d'identifiants.
#
# Ouvre UNE seule connexion réutilisable (option tunnel SOCKS/SSH pour les API
# derrière allowlist IP), boucle sur les ids et sur un ou plusieurs templates
# d'endpoint, journalise id,endpoint,http,rows en CSV et sauve les réponses 200
# non vides. Préférer ce script à des appels un par un.
#
# Usage :
#   sample_api.sh --base-url URL --ids FICHIER --endpoint 'TEMPLATE' [...] \
#                 [--auth 'Header: valeur'] [--ssh-host HOST] \
#                 [--out DIR] [--max N] [--max-time SEC]
#
# - FICHIER : un identifiant par ligne (ex. SIRET/SIREN tirés de
#   recherche-entreprises.api.gouv.fr).
# - TEMPLATE : chemin contenant le placeholder {id}, ex. '/v0/turnover-stock/{id}'.
#   Répétable (--endpoint A --endpoint B).
# - --auth : en-tête d'authentification, ex. "Authorization: Bearer $(cat .token)"
#   (passer le secret via $(cat ...), ne pas l'écrire en clair).
# - --ssh-host : si fourni, tunnel SOCKS5 dynamique via cet host (allowlist IP).
# - --out : dossier de sortie (défaut: payloads_raw). --max : nb max d'ids.
#
# Exemple :
#   sample_api.sh --base-url https://api-demo.example.gouv.fr \
#     --ids sirets.txt --ssh-host watchdoge \
#     --auth "Authorization: Bearer $(cat .token)" \
#     --endpoint '/v0/turnover-stock/{id}' --endpoint '/v0/pyramide-stock/{id}'

base_url="" ids_file="" auth="" ssh_host="" out="payloads_raw"
max=100 max_time=20
endpoints=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base-url) base_url="$2"; shift 2 ;;
    --ids)      ids_file="$2"; shift 2 ;;
    --auth)     auth="$2"; shift 2 ;;
    --ssh-host) ssh_host="$2"; shift 2 ;;
    --endpoint) endpoints+=("$2"); shift 2 ;;
    --out)      out="$2"; shift 2 ;;
    --max)      max="$2"; shift 2 ;;
    --max-time) max_time="$2"; shift 2 ;;
    *) echo "Option inconnue: $1" >&2; exit 64 ;;
  esac
done

[[ -n "$base_url" && -n "$ids_file" && ${#endpoints[@]} -gt 0 ]] || {
  echo "usage: $0 --base-url URL --ids FICHIER --endpoint 'TEMPLATE' [...] [--auth H] [--ssh-host HOST] [--out DIR] [--max N]" >&2
  exit 64
}
[[ -r "$ids_file" ]] || { echo "Fichier d'ids introuvable: $ids_file" >&2; exit 66; }

label() { echo "$1" | sed -E 's#\{id\}##; s#^/+##; s#/+$##; s#[/{}]+#_#g; s#_+#_#g; s#^_##; s#_$##'; }

rm -rf "$out"; mkdir -p "$out"
log="$(dirname "$out")/sample_log.csv"; [[ "$(dirname "$out")" == "." ]] && log="sample_log.csv"
echo "id,endpoint,http,rows" > "$log"

curl_args=(-sS --max-time "$max_time" -H "Accept: application/json")
[[ -n "$auth" ]] && curl_args+=(-H "$auth")

socks=""
if [[ -n "$ssh_host" ]]; then
  port="$(python3 -c 'import socket;s=socket.socket();s.bind(("127.0.0.1",0));print(s.getsockname()[1]);s.close()')"
  sock="$(mktemp -u -t sample-ssh.XXXXXX)"
  cleanup() { [[ -S "$sock" ]] && ssh -S "$sock" -O exit "$ssh_host" >/dev/null 2>&1 || true; }
  trap cleanup EXIT INT TERM
  echo "Tunnel SOCKS5 via $ssh_host (127.0.0.1:$port)" >&2
  ssh -fN -M -S "$sock" -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 \
      -D "127.0.0.1:$port" "$ssh_host"
  socks="127.0.0.1:$port"
fi

n=0
while read -r id; do
  id="$(echo "$id" | tr -d '\r\n ')"
  [[ -n "$id" ]] || continue
  n=$((n+1)); [[ $n -gt $max ]] && break
  for tpl in "${endpoints[@]}"; do
    lbl="$(label "$tpl")"; mkdir -p "$out/$lbl"
    path="${tpl//\{id\}/$id}"
    [[ -n "$socks" ]] && net=(--socks5-hostname "$socks") || net=()
    resp="$(curl "${curl_args[@]}" "${net[@]}" -w $'\n%{http_code}' "${base_url%/}${path}" || true)"
    code="${resp##*$'\n'}"; body="${resp%$'\n'*}"
    rows=0
    if [[ "$code" == "200" ]]; then
      rows="$(printf '%s' "$body" | jq 'if type=="array" then length elif type=="object" then 1 else 0 end' 2>/dev/null || echo 0)"
      [[ "$rows" -gt 0 ]] && printf '%s' "$body" > "$out/$lbl/$id.json"
    fi
    echo "$id,$lbl,$code,$rows" >> "$log"
  done
  printf '\r%d ids traités' "$n" >&2
done < "$ids_file"
echo >&2
echo "Terminé. Payloads: $out/  Logs: $log" >&2
