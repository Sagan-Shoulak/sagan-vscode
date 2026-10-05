# Sagan VS Code repository instructions

Use Bash commands when communicating with the owner; never give PowerShell
commands. Read `CODEX_START.md` once if present, then `TECHNOLOGY.md` and
`MAINTAINERS.md`. The first chat removes the tracked bootstrap prompt through
a PR; do not recreate it. These guides and the versioned ecosystem/chat maps
remain durable. Preserve unrelated changes and
report the exact files staged for any commit.

The language compiler and LSP belong to `Sagan-Shoulak/sagan`, not this
repository. This extension consumes their versioned contracts and must not
reimplement Sagan parsing or semantics.

Use issues for substantive work, linked PRs into `dev`, and the organization
Project for cross-repo milestones when accessible. Record focused checks,
compiler/LSP pins, and integration impact; track blocked Project access in
the issue. Keep the release and `main` promotion hold.

Route by owner: `sagan` language/toolchain, `sagan-vscode` editor,
`sagan-physics` numeric physics, `sagan-render` rendering,
`sagan-workspace` exact-lock integration, `sagan-docs` official site, and
`sagan-space-game` application/design. Handoffs to another chat must include
goal, evidence, constraints, pins, and verification.
