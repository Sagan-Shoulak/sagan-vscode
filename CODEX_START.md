# Starting a new sagan-vscode chat

Begin read-only. Read `AGENTS.md`, `TECHNOLOGY.md`,
`MAINTAINERS.md`, `README.md`, `sagan-source-commit.txt`, the
extension roadmap and documentation status fields. Inspect branch, HEAD,
status, staged paths, recent history, and the actual compiler/LSP version
and paths. The workspace repository exists but its component lock is not
fully active; compare its versioned ecosystem/chat maps with the primary
repository's maps. Report open gates,
concurrent work, platform support, exact Bash commands, and the safest
next step before changing state.

Prefer teaching me what to code through explanations, examples,
pseudocode, review, and small verification steps. Do not implement unless
I explicitly ask. Never infer that the language is secure. For every
authorized change, start a fresh `codex/<request>` branch from current
`dev`, refine until relevant tests pass, commit only intended paths,
merge into `dev`, and repeat the relevant tests there. A full suite is
for `main` promotion or release only. Documentation-only work does not
run unrelated executable examples; edited pages return to human
`review-needed`, `publication_ready: false`, and cleared verification
metadata.

The language chat owns compiler, LSP, DAP, units, and toolchain changes.
The physics and rendering chats own their libraries. The workspace chat
owns exact ecosystem locks and cross-repository integration; the
documentation chat owns the single published site; the game chat owns
application/design work and asks the owner clarifying questions about
game goals. If another chat owns the request, provide a self-contained
ready-to-paste handoff with goal, evidence, constraints, dependency
versions, and verification. Never assume chats share context.

Releases and `main` promotion are currently paused. Do not push,
publish, release, deploy, transfer, or change remote settings without
current permission. Preserve unrelated work. Give Bash, never
PowerShell, commands.

This tracked prompt is a one-time bootstrap. After reading it and orienting
read-only, delete `CODEX_START.md` on a short-lived branch, commit that
deletion and any required contract updates, then open a PR into `dev` linked
to an onboarding issue. Do not
recreate it; `AGENTS.md`, `TECHNOLOGY.md`, and `MAINTAINERS.md` remain the
durable instructions.

Use existing or new GitHub issues for substantive work, PRs into `dev` for
review, and the organization Project for cross-repo milestones when access
permits. Link each PR to its issue, record focused checks, compiler/LSP pins,
and integration impact, and update Project status. If Project access is
unavailable, record that in the issue and continue safe local verification.
The split is tracked by Sagan-Shoulak/sagan#6.
