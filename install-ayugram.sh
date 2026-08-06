#!/usr/bin/env bash
set -euo pipefail

repo="Mar2ianen/ayugram-desktop"
run_id="${AYUGRAM_RUN_ID:-31059958015}"
artifact="${AYUGRAM_ARTIFACT:-ayugram-desktop-linux-debug}"
install_dir="${XDG_DATA_HOME:-$HOME/.local/share}/ayugram-desktop"
bin_dir="$HOME/.local/bin"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

command -v gh >/dev/null || {
  printf 'GitHub CLI (gh) is required.\n' >&2
  exit 1
}

gh run download "$run_id" --repo "$repo" --name "$artifact" --dir "$tmp_dir"

shopt -s nullglob globstar
bundle=''
for candidate in "$tmp_dir"/**/*; do
  if [[ -f "$candidate" ]]; then
    bundle="$candidate"
    break
  fi
done

if [[ -z "$bundle" ]]; then
  printf 'No executable bundle found in artifact %s.\n' "$artifact" >&2
  exit 1
fi

bundle_dir="$install_dir/bundle"
rm -rf "$bundle_dir"
mkdir -p "$bundle_dir" "$bin_dir"
(cd "$bundle_dir" && "$bundle" --extract)

telegram_bin=''
for candidate in "$bundle_dir"/dat/nix/store/*-ayugram-desktop-*/bin/Telegram; do
  if [[ -x "$candidate" ]]; then
    telegram_bin="$candidate"
    break
  fi
done

if [[ -z "$telegram_bin" ]]; then
  printf 'Telegram executable was not found in extracted bundle.\n' >&2
  exit 1
fi

ln -sfn Telegram "${telegram_bin%/*}/AyuGram"

startup=''
for candidate in "$bundle_dir"/dat/nix/store/*-startup; do
  if [[ -x "$candidate" ]]; then
    startup="$candidate"
    break
  fi
done

if [[ -z "$startup" ]]; then
  printf 'Bundle startup script was not found.\n' >&2
  exit 1
fi

cat > "$bin_dir/ayugram-desktop" <<EOF
#!/bin/sh
set -eu
cd "$bundle_dir/dat"
exec "$startup" "\$@"
EOF
chmod +x "$bin_dir/ayugram-desktop"

printf 'Installed: %s\n' "$bin_dir/ayugram-desktop"
printf 'Run: ayugram-desktop\n'
