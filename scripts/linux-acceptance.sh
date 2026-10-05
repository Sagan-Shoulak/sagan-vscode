#!/usr/bin/env bash
set -euo pipefail

extension_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
extension_version="$(node -p "require('$extension_root/package.json').version")"
output_path="${1:-$extension_root/sagan-language-$extension_version.vsix}"

: "${SAGAN_COMPILER_PATH:?Set SAGAN_COMPILER_PATH to the matching Sagan compiler}"
: "${SAGAN_LSP_PATH:?Set SAGAN_LSP_PATH to the matching Sagan language server}"
[[ -x "$SAGAN_COMPILER_PATH" ]] || { echo "Compiler is not executable: $SAGAN_COMPILER_PATH" >&2; exit 1; }
[[ -x "$SAGAN_LSP_PATH" ]] || { echo "Language server is not executable: $SAGAN_LSP_PATH" >&2; exit 1; }

cd "$extension_root"
npm ci
npm test
npm run test:bundle
npm run test:integration
npm run package -- --out "$output_path"

test -s "$output_path"
printf 'Linux acceptance passed. VSIX: %s\n' "$output_path"
