---
name: skill-conductor
description: "Context-Driven Development (CDD) protocol for proactive project management."
---
# Gemini Conductor Skill

Conductor is a **Context-Driven Development (CDD)** protocol. It turns an AI agent into a proactive project manager that follows a strict protocol to specify, plan, and implement software features and bug fixes.

## Commands

| Command | Description |
| :--- | :--- |
| `/conductor:setup` | Scaffolds the project and sets up the Conductor environment. |
| `/conductor:newTrack` | Starts a new feature or bug track. Generates `spec.md` and `plan.md`. |
| `/conductor:implement` | Executes the tasks defined in the current track's plan. |
| `/conductor:status` | Displays the current progress of the tracks file and active tracks. |
| `/conductor:revert` | Reverts a track, phase, or task by analyzing git history. |
| `/conductor:review` | Reviews completed work against guidelines and the plan. |

## Protocol Summary

### 1. Setup (`/conductor:setup`)
Initialize the `conductor/` directory with:
- `product.md`: Product vision, goals, and user personas.
- `tech-stack.md`: Technical choices, languages, frameworks, and constraints.
- `product-guidelines.md`: Brand voice, UI/UX standards, and communication style.
- `workflow.md`: The development lifecycle (rules for TDD, commits, etc.).
- `tracks.md`: The registry of all work units.

### 2. New Track (`/conductor:newTrack`)
For every new feature or fix:
1. **Spec**: Define *what* is being built and *why*.
2. **Plan**: Break down the work into **Phases** and **Tasks**. Each task must be actionable.
3. **Register**: Add the track to `conductor/tracks.md`.

### 3. Implementation (`/conductor:implement`)
A strict loop:
1. **Selection**: Pick the next task from the plan.
2. **Workflow**: Follow `workflow.md` (e.g., TDD: Write Test -> Fail -> Implement -> Pass).
3. **Commit**: Use meaningful commit messages and attach summaries via `git notes`.
4. **CP Verification**: At the end of every phase, run tests and perform manual verification.

### 4. Synchronization & Cleanup
1. **Sync**: Update project-level docs (`product.md`, `tech-stack.md`) based on the completed track.
2. **Cleanup**: Archive or delete the track artifacts once finalized.

## Guidelines for the Agent
- **Adhere to the Plan**: Do not deviate from the current `plan.md` without formal revision.
- **Context is King**: Always read and update the core context files in `conductor/` to maintain the project's single source of truth.
- **Verification First**: Never mark a task as complete without passing tests and verification.
