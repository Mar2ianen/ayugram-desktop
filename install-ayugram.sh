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

mkdir -p "$install_dir" "$bin_dir"
install -Dm755 "$bundle" "$install_dir/ayugram-desktop"
ln -sfn "$install_dir/ayugram-desktop" "$bin_dir/ayugram-desktop"

printf 'Installed: %s\n' "$install_dir/ayugram-desktop"
printf 'Run: ayugram-desktop\n'
