# Sagan VS Code technology overview

This repository owns the VS Code client, TextMate grammars, extension
packaging, and editor integration tests. It does not own the Sagan compiler,
language server, parser, package catalog, physics, rendering, or game code.
Those responsibilities remain in their respective `Sagan-Shoulak`
repositories. The canonical cross-repository dependency and chat map is
currently staged in the intact `sagan` repository's
`repository-segmentation/` directory; `sagan-workspace` will own it after
the split.

VS Code loads `dist/extension.js`, bundled from `src/` by
`scripts/build-extension.js`. `syntaxes/` supplies lexical TextMate
coloring before semantic tokens arrive. The JavaScript client discovers a
compatible external `sagan` and `sagan-lsp`, checks the versioned
`sagan.language-service/1` capability response, and enables only advertised
LSP and Sagan operation features. Native binaries are **not** bundled in
the VSIX. Editing compiler behavior requires a matching native build or
installation; rebuilding this extension alone cannot update diagnostics.

`package-lock.json` fixes Node dependencies. `sagan-source-commit.txt`
fixes the exact public compiler source revision for the initial independent
CI matrix. The workflow checks out that revision as a sibling of this
repository, builds compiler and LSP on Linux, macOS, and Windows, and runs
the extension suite with explicit executable paths. A sibling checkout
prevents compiler source or native outputs from entering the VSIX.
The pin is an integration contract, not a claim that every later Sagan
revision is compatible. Update it only with relevant cross-platform tests.

`npm test` covers grammar and mocked client behavior; `npm run
test:bundle` checks the shipped entry point; `npm run test:integration`
starts a real VS Code Extension Development Host and validates the bundled
demo with the external compiler. `scripts/vscode/build_release.sh`
packages a VSIX and SHA-256; `scripts/vscode/test_release.sh` checks the
package, isolated installation, and native-tool activation. The build
directory, `dist/`, and `.vscode-test/` are generated outputs, not
authoritative source.

The extension's documentation lives here for component ownership and is
intended to appear in the single official Sagan documentation site through
the docs repository's aggregation contract. Imported pages currently have
`publication_ready: false`; editing a page resets it to human
`review-needed` and clears verification metadata. Publication and
cross-repository link assembly are owned by the documentation chat.

See `MAINTAINERS.md` for exact commands, release holds, test selection,
and recovery. See `README.md` for user-visible behavior and
`docs/tooling/vscode-extension-roadmap.md` for open capabilities.
