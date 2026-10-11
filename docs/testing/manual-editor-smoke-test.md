# Manual editor smoke test

Use this checklist to assess visual and interactive behavior that the automated
Extension Development Host suite cannot judge. Run it against an installed
VSIX and the exact compiler/language-server pair intended for distribution.
This is an acceptance procedure, not permission to enable unadvertised package
or debugger features.

## Record the test context

Before opening VS Code, record:

- operating system and version;
- VS Code version and file-icon theme;
- VSIX filename and SHA-256;
- Sagan compiler version and source commit;
- `sagan-lsp` version and source commit;
- whether compiler and server paths are configured or automatically discovered.

Create a fresh VS Code profile, install only the candidate VSIX, and open a
copy of `tests/integration/workspace`. Keep the fixture copy disposable because
rename and formatting checks modify documents.

## Visual and interactive checks

1. Open `main.sagan`. Confirm the Sagan language mode, Sagan file icon, and
   distinct highlighting for declarations, types, calls, literals, and comments.
2. Run **Sagan: Show Tooling Status**. Confirm it names the discovered binaries
   and reports package completion, navigation, and auto-import as supported
   while keeping debugger support unavailable.
3. Introduce an unresolved name. Confirm a diagnostic appears in the editor and
   Problems view, its range covers the intended text, and removing the edit
   clears it.
4. Trigger completion, hover, signature help, go-to-definition, references,
   implementation navigation, and type definition. Confirm each result points
   at the expected source and does not jump into generated or unrelated files.
5. Inspect document and workspace symbols, breadcrumbs, folding, selection
   ranges, semantic highlighting, inlay hints, and incoming call/type
   hierarchies. Confirm labels and ranges remain legible in both light and dark
   themes.
6. Format the document, a selected range, and a closing brace. Confirm indentation
   changes are confined to the expected region and incomplete code is not
   destructively rewritten.
7. Remove a closing brace and invoke **Quick Fix**. Confirm the compiler-issued
   repair is offered and previews only the missing delimiter edit.
8. Rename a local binding and the public `Probe.sample` member. Confirm the
   preview lists every intended file, apply once, then verify one Undo restores
   all affected documents.
9. Open `manifest_project/sagan.toml`. Confirm manifest language mode, icon,
   highlighting, diagnostics, completion, hover, symbols, entry navigation,
   document formatting, and selected-range formatting. Do not expect manifest
   on-type formatting or safe fixes.
10. Open `package-workspace/src/main.sagan`. Confirm completion and navigation
    reach the installed `orbit-tools` fixture. From an unimported use in the
    package entry document, accept the `orbit_answer` completion and confirm
    VS Code adds `import orbit_answer from orbit_tools.main` with the symbol.
11. Switch among the default Seti/Minimal icon themes and one commonly used
    third-party file-icon theme. Record whether `.sagan` and `sagan.toml` remain
    distinguishable; a third-party theme may intentionally replace contributed
    icons, so record the observed precedence rather than changing language logic.

## Evidence and result

For each platform, save:

- pass/fail for each numbered check;
- screenshots for the file icon, tooling status, diagnostic, semantic colors,
  hierarchy view, rename preview, quick-fix preview, and manifest mode;
- sanitized Sagan output-channel logs for failures;
- exact reproduction steps and whether the same behavior appears with all other
  extensions disabled.

Acceptance requires every compiler-advertised interaction to pass on Windows,
Linux, and macOS. File-icon differences caused solely by a selected theme are
documented compatibility observations. Any semantic discrepancy is handed to
`Sagan-Shoulak/sagan` with the compiler/LSP pins and a minimal fixture; extension
activation, packaging, discovery, or presentation failures stay in this
repository.
