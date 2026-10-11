---
title: VS Code extension roadmap
status: review-needed
publication_ready: false
verified_in: null
verified_on: null
verified_by: null
---

# VS Code extension roadmap

Version 0.3.6 is a usable language client for the capabilities currently
advertised by `sagan-lsp`. This roadmap lists work that remains after the
initial client integration. The extension must continue to consume compiler
contracts rather than reproduce parsing, semantics, project rules, or catalogs.
The independent repository has a pinned-source CI workflow whose Linux, macOS,
and Windows jobs pass in the destination repository.

## Accepted capability matrix

The extension accepts the running compiler and language server's versioned
capability response as authoritative. The current completion boundary is:

| Capability group | Current contract | Extension action |
| --- | --- | --- |
| Standard LSP editor features | Advertised by `sagan-lsp` | Consume through `vscode-languageclient`; do not duplicate providers. |
| Check/build/run | Native operations and cancellation advertised | Commands and tasks implemented. |
| Test Explorer | Granular document/project discovery and run advertised | Test Explorer implemented from the granular flags. |
| Manifest editing | Diagnostics, completion, hover, symbols, navigation, and document/range formatting advertised | Consume the LSP surface; on-type formatting and safe fixes remain unavailable. |
| Package foundations | Index reader, query, and catalog advertised | Treat as compiler foundations; do not crawl packages in JavaScript. |
| Complete package UX | Completion, navigation, and auto-import flags false | Wait for the compiler/LSP contract and tests. |
| Debug foundations | Source maps, metadata, and launch planning advertised | Treat as metadata only. |
| Debugger UI | All live DAP capability flags false | Do not register a Sagan debug type yet. |

The ordered extension plan is to improve capability/status presentation first,
expand representative live-editor acceptance coverage second, consume package
features only as their individual flags become true, and add debugger UI only
after the granular DAP flags and release-payload gates pass. Stable publication
and `main` promotion remain separate decisions.

## Current compiler handoff checkpoint

Extension work can consume standard LSP improvements as they land while the
compiler-side package and debugger contracts below are completed. The earlier
1.8.0 checkpoint is historical, not the present handoff. The extension must
not enable capabilities that discovery still reports as false.

Most ordinary editor support is ready. The language server supplies compiler-
backed diagnostics, formatting, hover, definition, references, completion,
signature help, symbols, semantic tokens, rename, hierarchies, code actions,
and cancellable build/run/test operations. Offline package resolution through
manifest aliases and `sagan.lock` is also available. Imported package symbols
have tested hover, definition, and completion paths, and incomplete selective
and module imports have compiler-owned suggestions and navigation.

Reaching the next extension handoff requires several focused compiler-side
increments followed by a release-payload validation pass. The preferred order
is package completion and safe auto-import first, then debugger values and
runtime-failure mapping, then debugger packaging and cross-platform validation.

## Dependable F2 rename

F2 rename is available for compiler-proven local bindings, constants,
parameters, loop and match bindings, private members, non-exported functions,
exported identity groups, public members of exported types, enum cases,
imports, aliases, and namespace-qualified references. A function named `main`
is an ordinary function; executable entry behavior belongs to the selected
root document rather than that spelling.

The language server advertises `prepareRename`, returns versioned atomic
workspace edits, revalidates renamed identity groups, and refuses collisions,
ambiguous receiver types, stale snapshots, incomplete source, and other cases
it cannot prove safe. The live Extension Development Host suite covers local
and declaration-position rename, imported public-member navigation, cross-file
public-member rename, exported names with independent import aliases, collision
refusal, emoji identifiers, private fields, private mutating methods, and
one-step undo of both single- and multi-file edits.

Rename refusals use the LSP `RequestFailed` response and preserve the
compiler-owned explanation, allowing VS Code to show actionable messages for
invalid names, collisions, ambiguous identities, stale snapshots, and other
unsafe cases. Remaining rename readiness work is acceptance-matrix refinement
rather than a missing core provider: preserve protocol cancellation coverage.

## Deferred external release validation

These items are intentionally saved for much later and are not prerequisites
for continued local extension development:

- Run a manual VS Code smoke-test matrix on Windows, Linux, and macOS covering
  activation, diagnostics, completion, hover, navigation, signature help,
  semantic tokens, formatting, rename, code actions, and hierarchies. The
  reproducible procedure and evidence template live in
  [`../testing/manual-editor-smoke-test.md`](../testing/manual-editor-smoke-test.md).
  The automated Windows integration path is now verified; platform-specific visual
  behavior, including file-icon theme interaction, and features outside its
  representative request set remain.
- Keep the **independent-repository** automated Extension Development Host
  integration suite passing on each supported CI platform. The dedicated
  workflow builds the matching
  compiler and server and runs unit, bundle, and live-host tests on Windows,
  Linux, and macOS; those hosted jobs have passed. The suite
  covers real activation, diagnostics, hover, definition, completion,
  signature help, symbols, and formatting without making ordinary unit tests
  network-dependent. A clean
  Pop!_OS 24.04 VM has passed the compiler/server build, extension tests,
  Extension Development Host integration, VSIX installation, activation,
  file-icon, highlighting, diagnostic, and tooling-discovery checks; CI and
  the complete manual Linux feature matrix remain.
- Decide whether to publish through the Visual Studio Marketplace. Until then,
  distribute the VSIX with matching Sagan release assets.

## Extension-owned release work

- Release automation includes the matching native compiler and language server
  in Windows installer/portable payloads, verifies the VSIX checksum and
  contents, installs the packaged VSIX into an isolated VS Code profile, and
  activates the extension against that native pair before publication.
- Add user-facing troubleshooting for server crashes, incompatible schemas,
  quarantined executables, and platform runtime dependencies as real failures
  are observed.

## Capability-driven extension features

- The compiler library and LSP now expose cancellable check/build/run
  operations with versioned results and progress. The extension consumes them
  through cancellable commands and document/project tasks; the server currently
  serializes requests rather than scheduling concurrent operations.
- Test Explorer consumes compiler-issued stable IDs, UTF-16 ranges, document
  and project discovery, selected document execution, structured outcomes, and
  cancellation. When `testProjectRun` is advertised, selections spanning
  multiple modules execute as one authoritative project run; older servers
  retain the document-run fallback.
- Recovered-source document, range, and on-type formatting uses the existing
  LSP providers when `recoveredFormatting` is advertised; uncertain regions
  receive no speculative edits.

## Compiler- or protocol-blocked goals

- The compiler-owned `sagan.toml` service is connected through the extension's
  manifest document selector. Live-host coverage exercises diagnostics,
  completion, hover, symbols, entry navigation, and valid whole-document
  formatting. The compiler also owns locked-dependency navigation and
  installed-package requirement completion. Manifest on-type formatting and
  safe quick fixes remain unavailable; extend tests as those capabilities
  become supported. The extension must not reproduce manifest parsing or
  validation in TypeScript.
- Finish package completion in every relevant import, export, qualified-name,
  type, expression, and receiver context. Add compiler-owned safe auto-import
  edits, alias and collision handling, navigation when installed source is
  missing, and focused multi-root conflict tests. Existing lockfile resolution,
  selective-import navigation, catalog queries, and tested package hover,
  definition, and completion cases are foundations rather than the completed
  contract. Keep `packageCompletion`, `packageNavigation`, and
  `packageAutoImport` false until their individual end-to-end gates pass.
- Finish the experimental Debug Adapter Protocol implementation. `sagan-dap`
  can launch programs and exercise breakpoints, mapped stacks, source-mapped
  stop-on-entry, and source-level
  stepping. Windows portable packaging now contains GDB, its Python runtime,
  and the adapter, and an extracted ZIP passed the DAP suite outside MSYS2.
  Initialized scalar and UTF-8 String locals and parameters have guarded value
  probes, while collections, nested values, exception stops, broader source-context
  and cleanup coverage, Linux distribution validation, and isolated installer
  smoke validation remain. The extension must not register a supported
  Sagan debug type while all granular debugger capability flags remain false.

## Resume sequence

When compiler work resumes, complete and advertise each capability separately
rather than waiting for one large final patch:

1. Complete contextual package completion and its protocol tests.
2. Complete safe package auto-import edits, aliases, and multi-root conflicts.
3. Complete missing-source package navigation behavior.
4. Complete Sagan debugger values and runtime-failure/exception mapping.
5. Expand DAP source-context, cancellation, termination, and cleanup tests.
6. Package the debugger backend and validate Windows outside MSYS2 plus Linux.
7. Hand the tested schemas, executable-discovery contract, capability truth
   table, runtime dependencies, and validation results back to the extension.
8. Register only the newly advertised VS Code features, rebuild the VSIX, and
   rerun unit, bundle, isolated-install, activation, and live-host tests.

## Deliberate non-goals

- Reimplementing compiler syntax or semantic analysis in TypeScript.
- Guessing unavailable library, package, test, or debugger APIs.
- Enabling a feature that the running server does not advertise.
