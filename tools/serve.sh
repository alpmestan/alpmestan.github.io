#!/usr/bin/env bash

set -euo pipefail

mkdir -p _out && cd _out/
python3 -m http.server "${PORT:-8000}" &
http_server_pid="$!"
trap 'kill "$http_server_pid"' EXIT

cd -

watchexec -w src -w public --exts md --exts css --exts html5 -q -- make
