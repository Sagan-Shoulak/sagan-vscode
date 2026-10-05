# Maintaining sagan-vscode

This repository owns only the VS Code extension. Keep the compiler and LSP
in `Sagan-Shoulak/sagan`; keep ecosystem locks/integrated demos in
`sagan-workspace` and official site publication in `sagan-docs`.
The current organization-wide hold pauses releases and `main` promotion
until the owner explicitly reopens publication and decides the signing
policy. A passing test suite is not permission to publish.

## Clean-machine prerequisites and bootstrap

Install Git, Node.js 22, npm, and the native compiler toolchain for the
platform. CI uses GNU make and GCC on Linux, Clang on macOS, and MSYS2
UCRT64 make/GCC on Windows. VS Code or a downloadable VS Code test runtime
is needed for live-host tests. Do not copy native binaries into this
extension package.

The workflow checks out the full history at the exact native source pin;
Sagan calculates its compiler version from a baseline commit, so a shallow
source checkout can build an incorrectly identified toolchain. In a Bash
shell from this repository root, obtain the exact native source:

```bash
git clone https://github.com/Sagan-Shoulak/sagan.git ../sagan-source
git -C ../sagan-source checkout --detach "$(tr -d '\r\n' < sagan-source-commit.txt)"
git -C ../sagan-source rev-parse HEAD
```

The printed SHA must equal `sagan-source-commit.txt`. In Linux or MSYS2
UCRT64 Bash, build with:

```bash
(cd ../sagan-source && make all bin/sagan-lsp)
```

On macOS use `make CXX=clang++ all bin/sagan-lsp` inside
`../sagan-source`. On Windows the binaries end in `.exe`; use the
MSYS2 UCRT64 shell so its compiler and runtime are on `PATH`. In Bash,
set explicit paths before live tests. For Windows:

```bash
export SAGAN_COMPILER_PATH="$(cd ../sagan-source && pwd)/bin/sagan.exe"
export SAGAN_LSP_PATH="$(cd ../sagan-source && pwd)/bin/sagan-lsp.exe"
```

For Linux/macOS, use the same paths without `.exe`. Then run:

```bash
npm ci
npm test
npm run test:bundle
npm run test:integration
```

The live test downloads or reuses a VS Code runtime. Linux CI uses
`xvfb-run --auto-servernum npm run test:integration`; a headless local
Linux host needs the same display wrapper. The extension's own files and
Node lockfile are sufficient for unit and bundle tests; only the live test
needs native binaries.

## Branch and test workflow

For every authorized change request, start a new `codex/<request>` branch
from current `dev`. Inspect `git status --short --branch` and
`git diff --cached --stat` before staging or committing. Test and refine
the affected work on that branch. Commit only intended paths, merge the
finished branch into `dev`, and rerun the relevant tests against integrated
`dev`, accounting for any concurrent changes. Do not run the full suite
merely because `dev` changed.

After the segmentation freeze is lifted and remote work is authorized, the
standard Bash sequence is:

```bash
git fetch origin dev
git switch dev
git merge --ff-only origin/dev
git switch -c codex/editor-request
# Make the requested change, run its focused checks, and review staged paths.
git add -- path/to/intended-file
git diff --cached --check
git commit -m "Describe the focused change"
git switch dev
git fetch origin dev
git merge --ff-only origin/dev
git merge --no-ff codex/editor-request
# Repeat the relevant checks on integrated dev before an authorized push.
git push origin dev
```

Replace the illustrative branch name and staged path with the actual
request and files. If `dev` moved, resolve integration and rerun relevant
checks before pushing. Never use `git push --force` on shared branches.

- Grammar, package metadata, fixtures, or client code: `npm test` and
  `npm run test:bundle`; add `npm run test:integration` for LSP
  wiring, activation, discovery, or supported capability changes.
- VSIX build or install scripts: `bash scripts/vscode/build_release.sh`,
  then `bash scripts/vscode/test_release.sh` with both native-tool
  environment variables set. The latter installs only into an isolated
  VS Code test profile.
- Documentation-only changes: check links, metadata, and site structure
  through the docs repository. Do not run unrelated executable examples.
  Any edited page becomes `review-needed` with
  `publication_ready: false` and cleared verification fields.
- Compiler source pin or CI workflow: run unit, bundle, and live-host checks
  locally where possible, then require the hosted Linux/macOS/Windows
  matrix before calling the change integrated. Update the pin to one exact
  full commit SHA, never a floating branch or tag.

The complete extension suite, hosted three-platform matrix, VSIX checksum,
isolated installation, compatibility check against the pinned native source,
and documentation review are required before any future `dev` to `main`
promotion or release. The current publication hold still takes precedence.

## Packaging, failures, and recovery

`bash scripts/vscode/build_release.sh` writes
`build/release/sagan-language-VERSION.vsix` and a SHA-256 sidecar.
`bash scripts/vscode/test_release.sh` verifies the sidecar, expected
contents, isolated installation, and activation against matching native
tools. Neither command publishes a release. The VSIX does not contain the
compiler or LSP; a missing runtime DLL or stale diagnostic points to the
native installation or executable path, not necessarily the extension.
Use **Sagan: Show Tooling Status** to inspect discovered paths.

If a candidate branch or package fails, keep `dev` and `main` untouched,
fix the branch, and rerun focused tests. If an integrated `dev` change
fails, use a reviewed forward-fix or revert commit; do not reset a shared
branch. If a future release or docs aggregation fails, stop publication,
retain checksummed artifacts and prior released refs, and follow the
organization's workspace/docs rollback runbooks. Never force-push or
publish inherited Sagan language tags as extension releases.

Initial GitHub governance is public visibility, `dev` default, and a
protected linear-history `main` without force-push or deletion. Only
JoePShoulak initially has admin access. Do not copy secrets, runner
credentials, release environments, or other repository settings from
`sagan` without a separate reviewed need. The final owner-survivability
drill and destination rollback record must be completed before the first
remote split; this guide is not evidence that they have run.
