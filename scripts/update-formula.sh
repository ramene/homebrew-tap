#!/bin/bash
# Fill a formula's release version (its single `release = "X.Y.Z"` line) and its three sha256 lines from a release's SHA256SUMS.
# usage: scripts/update-formula.sh <cloud-sessions|remote-sessions> <version> <path to SHA256SUMS>
# Refuses (and changes nothing) if SHA256SUMS lacks any of macos-universal, linux-x86_64, linux-aarch64.
set -eu
[ "$#" -eq 3 ] || { echo "usage: $0 <cloud-sessions|remote-sessions> <version> <path to SHA256SUMS>" >&2; exit 64; }
name="$1"; version="$2"; sums="$3"
case "$name" in cloud-sessions|remote-sessions) ;; *) echo "unknown formula: $name" >&2; exit 64 ;; esac
case "$version" in [0-9]*.[0-9]*.[0-9]*) ;; *) echo "version must look like 1.2.3, got: $version" >&2; exit 64 ;; esac
[ -f "$sums" ] || { echo "no such file: $sums" >&2; exit 66; }
root="$(cd "$(dirname "$0")/.." && pwd)"
formula="${FORMULA_FILE:-$root/Formula/$name.rb}"
[ -f "$formula" ] || { echo "no such formula: $formula" >&2; exit 66; }

sha_for() { # label -> sha256 of $name-$version-<label>.tar.gz
  local file="$name-$version-$1.tar.gz" sha
  sha="$(awk -v f="$file" '{n=$2; sub(/^\*/,"",n); sub(/^.*\//,"",n)} n==f {print $1; exit}' "$sums")"
  if printf %s "$sha" | grep -Eq '^[0-9a-f]{64}$'; then echo "$sha"; else echo "REFUSED: $sums has no valid sha256 for $file" >&2; return 1; fi
}
mac="$(sha_for macos-universal)" || exit 1
lx="$(sha_for linux-x86_64)" || exit 1
la="$(sha_for linux-aarch64)" || exit 1

tmp="$(mktemp "$formula.XXXXXX")"
trap 'rm -f "$tmp"' EXIT
awk -v ver="$version" -v mac="$mac" -v lx="$lx" -v la="$la" '
  /^  release = "/ { print "  release = \"" ver "\""; next }
  /^ *url .*-macos-universal\.tar\.gz/ { cur = mac }
  /^ *url .*-linux-x86_64\.tar\.gz/ { cur = lx }
  /^ *url .*-linux-aarch64\.tar\.gz/ { cur = la }
  /^ *sha256 "/ { if (cur == "") { bad = 1 } sub(/sha256 ".*"/, "sha256 \"" cur "\""); cur = ""; n++ }
  { print }
  END { if (bad || n != 3) exit 1 }
' "$formula" > "$tmp" || { echo "REFUSED: $formula does not have exactly three url/sha256 pairs" >&2; exit 1; }
cat "$tmp" > "$formula"
echo "updated $formula: version $version"
echo "  macos-universal $mac"
echo "  linux-x86_64    $lx"
echo "  linux-aarch64   $la"
