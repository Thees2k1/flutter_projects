# AGENTS.md

Guidance for AI coding agents working in this workspace.

## Workspace Shape

- This workspace contains many independent Flutter apps under one folder.
- A workspace file (`from_tutorials.code-workspace`) includes two roots: the monorepo root and `clean_todo_v2`.
- Treat each app folder as its own project with its own `pubspec.yaml`.

## Pick The Target App First

Before edits or commands, identify the target app directory (for example `clean_todo_v2`, `clean_todolist`, `poke_api_integration`, `github_desktop_client`).

Run commands from that app's root, not from the monorepo root.

## Core Flutter Commands

From the selected app directory:

1. `flutter pub get`
2. `flutter analyze`
3. `flutter test`
4. `flutter run` (when runtime validation is needed)

## Code Generation Projects

Some apps use generated code (for example Drift/JSON codegen). After changing schema/annotated models, run:

1. `dart run build_runner build`

Reference implementations:

- `clean_todolist`
- `poke_api_integration`

## Project Maturity Expectations

- `clean_todo_v2` is currently minimal scaffold (`lib/main.dart`) and uses `flutter_lints`.
- `clean_todolist` and `poke_api_integration` demonstrate layered structure (`domain`, `data`, `presentation`).
- `github_desktop_client` uses stricter linting (`very_good_analysis`) and CI workflows.

When adding substantial features to `clean_todo_v2`, prefer growing toward the existing layered pattern used in `clean_todolist`.

## Conventions And Guardrails

- Respect existing lints from each app's `analysis_options.yaml`.
- Do not assume shared dependencies across apps.
- Keep changes scoped to one app unless user explicitly asks for cross-app work.
- Generated/plugin files and build outputs are ignored; do not hand-edit generated files.

## Useful References

- Root workspace overview: [README.md](README.md)
- Target app quick start: [clean_todo_v2/README.md](clean_todo_v2/README.md)
- Layered architecture example: [clean_todolist/README.md](clean_todolist/README.md)
- CI command baseline: [github_desktop_client/.github/workflows/main.yaml](github_desktop_client/.github/workflows/main.yaml)
