# Gemini Conductor Style Guide

Generate and maintain Conductor protocol files following Context-Driven Development conventions.

**References:** [Conductor Protocol](../workflow.md) | [Tech Stack](../tech-stack.md) | [Product Guidelines](../product-guidelines.md)

## Conductor File Structure

Every track lives in `conductor/tracks/<track-name>/`:

```
conductor/
├── product.md             # Product vision, goals, personas
├── tech-stack.md          # Approved technologies and constraints
├── product-guidelines.md  # Brand voice, UI/UX, communication standards
├── workflow.md            # Development lifecycle rules
├── tracks.md              # Registry of all active and completed tracks
├── tracks/
│   └── <track-name>/
│       ├── spec.md        # What and why — requirements and acceptance criteria
│       └── plan.md        # How — phases, tasks, dependencies
└── code_styleguides/      # Per-language style references (this directory)
```

## spec.md Format

```markdown
# Spec: <Feature or Fix Name>

## Problem Statement
One paragraph. What is broken or missing and why it matters.

## Goals
- Concrete, testable outcomes
- Written as user-observable behaviors

## Non-Goals
- Explicitly excluded scope to prevent scope creep

## Acceptance Criteria
- [ ] Criterion 1 — specific and verifiable
- [ ] Criterion 2 — specific and verifiable

## Constraints
- Technical constraints (must use X, cannot break Y)
- Time or resource constraints

## Open Questions
- Unresolved decisions that block planning
```

## plan.md Format

```markdown
# Plan: <Feature or Fix Name>

## Overview
One paragraph summary of the implementation approach.

## Phase 1: <Phase Name>

### Task 1.1 — <Task Name>
- **Action**: Specific imperative instruction (e.g., "Create file X", "Modify function Y")
- **File**: Path relative to repo root
- **Acceptance**: How to verify this task is done

### Task 1.2 — <Task Name>
- **Action**: ...
- **File**: ...
- **Acceptance**: ...

## Phase 2: <Phase Name>
...

## Verification
- Commands to run at end of all phases to confirm success
- Test commands, lint commands, manual verification steps
```

## tracks.md Format

```markdown
# Tracks

## Active

| Track | Status | Phase | Updated |
|---|---|---|---|
| track-name | In Progress | Phase 2 | 2026-04-07 |

## Completed

| Track | Completed | Summary |
|---|---|---|
| track-name | 2026-04-01 | One-line summary of what was built |
```

## Writing Rules

### Spec Rules
- **Problem Statement**: State the current broken state, not the desired future state
- **Goals**: Use verb phrases ("User can X", "System returns Y within Z ms")
- **Acceptance Criteria**: Every criterion must be binary — it either passes or it does not
- **Non-Goals**: Be explicit. "We will not X" prevents future misunderstanding

### Plan Rules
- **Tasks must be atomic**: Each task changes one thing in one place
- **Tasks must be ordered**: Later tasks may depend on earlier ones; earlier tasks must not depend on later ones
- **Tasks must be verifiable**: Each task has a specific file path and acceptance condition
- **No vague verbs**: Use "Create", "Modify", "Delete", "Move", "Rename" — not "Update", "Fix", "Improve"

### Phase Rules
- Each phase must produce a working state — the codebase must be runnable after each phase
- Phase names describe the architectural concern, not the implementation action ("Data Layer", not "Write Code")
- End each phase with explicit verification commands

## conductor/ Files: What Goes Where

| Content | File |
|---|---|
| Product vision, target users, success metrics | `product.md` |
| Approved languages, frameworks, cloud services | `tech-stack.md` |
| Code quality standards, naming conventions | `product-guidelines.md` |
| Commit format, TDD rules, PR process | `workflow.md` |
| Active and completed track registry | `tracks.md` |
| Per-language style rules | `code_styleguides/<lang>.md` |
| Per-track requirements | `tracks/<name>/spec.md` |
| Per-track implementation plan | `tracks/<name>/plan.md` |

## Commit Message Format

Every commit made during conductor implementation must follow:

```
<type>(<scope>): <imperative description>

<body — optional, explains why not what>

Track: <track-name>
Task: <phase>.<task>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

Example:
```
feat(auth): add JWT refresh token rotation

Implements sliding window refresh to prevent token theft via replay.
Refresh tokens are single-use and immediately invalidated on use.

Track: auth-hardening
Task: 2.3
```

## Code Review Checklist for Conductor Tracks

- [ ] `spec.md` has measurable acceptance criteria (not vague descriptions)
- [ ] `plan.md` tasks are atomic and ordered by dependency
- [ ] Each phase ends with explicit verification commands
- [ ] No task references a file path that does not exist or will not exist by that task
- [ ] `tracks.md` updated to reflect current track status
- [ ] Commit messages include Track and Task references
- [ ] All acceptance criteria in `spec.md` are checked off before marking track complete

---

*Based on: Conductor Context-Driven Development protocol. See `conductor/workflow.md`.*
