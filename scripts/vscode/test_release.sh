#!/usr/bin/env bash
set -euo pipefail

export PATH="/c/msys64/ucrt64/bin:/ucrt64/bin:/usr/bin:/bin:$PATH"

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
extension_version="$(cd "$repo_root" && npm pkg get version | tr -d '"[:space:]')"
vsix="${1:-$repo_root/build/release/sagan-language-$extension_version.vsix}"
checksum="$vsix.sha256"
compiler="${SAGAN_COMPILER_PATH:-}"
server="${SAGAN_LSP_PATH:-}"
unpack_dir="$repo_root/build/vsix-smoke"

[[ -f "$vsix" ]] || { echo "Missing VSIX: $vsix" >&2; exit 1; }
[[ -f "$checksum" ]] || { echo "Missing VSIX checksum: $checksum" >&2; exit 1; }
[[ -n "$compiler" && -x "$compiler" ]] || { echo "Set SAGAN_COMPILER_PATH to a matching executable." >&2; exit 1; }
[[ -n "$server" && -x "$server" ]] || { echo "Set SAGAN_LSP_PATH to a matching executable." >&2; exit 1; }

(cd "$(dirname "$vsix")" && sha256sum -c "$(basename "$checksum")")
rm -rf "$unpack_dir"
mkdir -p "$unpack_dir"
unzip -q "$vsix" -d "$unpack_dir"
node "$repo_root/scripts/vscode/verify_release.js" \
  "$unpack_dir/extension/package.json" "$extension_version"
node "$repo_root/scripts/vscode/install_release_test.js" "$vsix" "$extension_version"

cd "$repo_root"
SAGAN_COMPILER_PATH="$compiler" SAGAN_LSP_PATH="$server" npm run test:integration

echo "VSIX checksum, contents, isolated installation, and matching native-tooling activation checks passed."
