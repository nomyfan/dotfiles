---
name: engineer-requirement
description: Understand and clarify requirements through targeted conversation before design begins. Use when the requirement needs discussion — whether because the user's description is brief and vague, or because the problem is inherently complex with cross-cutting concerns, competing priorities, or non-obvious boundaries that need to be explored and resolved. Not needed when the problem is already well-defined with clear scope, scenarios, and constraints.
---

# Engineer Requirement

## When This Skill Runs

The user has an idea, a need, or a problem — but hasn't fully articulated it yet. This skill turns that into a clear, shared understanding of what needs to be solved, written down so design and implementation can work from it without re-deriving context from a long conversation.

**Do not skip this skill when the input is vague.** A one-sentence request like "add an export function" or "we need better error handling" is not a requirement — it's a starting point for a conversation. Jumping straight to design with this level of clarity produces solutions to the wrong problem.

**Do skip this skill when the input is already clear.** If the user provides a detailed spec, links to a ticket with full context, or describes the problem with enough specificity that you could confidently make design decisions, go directly to design. Don't force a clarification ritual when there's nothing to clarify.

## How to Clarify

Read the user's request and any relevant existing code. Then assess what you understand and what you don't. Specifically, check whether you can confidently answer:

- **What problem is being solved, and why now?** Not what feature to build — what pain or gap exists today. If the user said "add an export function," you need to know what they're exporting, who needs it, and what they do today without it.
- **Who encounters this and in what situation?** Concrete scenarios, not abstract personas. "The ops team pulls last month's data into Excel for finance review" is useful; "users want to export data" is not enough.
- **What does "done" look like?** What should be true when this ships that isn't true today?
- **What's out of scope?** Things the user has already considered and decided not to do, or wants to defer.
- **What constraints exist?** Deadlines, systems to integrate with, performance expectations, backward compatibility, team or organizational constraints.

**Ask about the gaps you actually found, not every bullet above.** Read the codebase first — it often answers questions about existing interfaces, data shapes, and constraints without bothering the user. Only ask the user things the code can't tell you.

Use targeted, specific questions. Use the structured user-input tool when available and there are discrete options to choose from; otherwise ask concise plain-text questions. Don't dump a checklist — pick the most important unknowns and ask those first.

**Pace:** typically one or two rounds of questions. Listen to the answers — they often reveal new gaps or resolve multiple questions at once. If after two rounds there are still significant unknowns, summarize what you understand and what's still unclear, and ask the user whether to proceed with stated assumptions or keep clarifying.

**Tone:** this is a conversation, not a requirements workshop. The goal is to reach a shared understanding quickly. Don't interrogate; don't be ceremonial. Ask what you need, listen, move on.

## Output

Once the problem is clear, write a requirement summary to `docs/requirement/{slug}.md`, where `{slug}` is a short kebab-case name for the requirement (e.g. `async-export-pipeline`). This file is the handoff to design — it should contain everything needed to start designing without re-reading the conversation.

Use this structure. Keep it concise — the entire file should typically be under 50 lines. Omit sections that add nothing.

```
## Problem
What is being solved, for whom, and why now. Keep it concise, but use the space
the problem actually needs — a simple problem is a sentence, a complex one may
need a short paragraph with background and context.

## Scenarios
Concrete user scenarios that define the requirement.
Each scenario: who does what, in what situation, and what outcome they need.

## Scope
In: what this requirement covers.
Out: what it deliberately does not cover, and why.

## Constraints
Technical, organizational, or timeline constraints that will shape the solution.

## Success Criteria
What must be true for this to be considered done.
Specific, verifiable statements — not vague qualities.
```

**Approval gate.** After writing the requirement summary, stop and ask the user to review it. Point to the file path and give a one-sentence summary of the core problem as you understood it. Do not proceed to design until the user confirms the requirement is captured correctly. If the user wants changes, revise and ask again.
