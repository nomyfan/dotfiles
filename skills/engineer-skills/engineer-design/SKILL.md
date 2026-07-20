---
name: engineer-design
description: Guide engineers through design before code for new feature design, module decomposition, architecture decisions, interface or data model design, and significant refactors. Also re-runs mid-implementation when work reveals that a load-bearing decision in an existing design brief needs to change. Not intended for small, well-scoped changes with a clear implementation path — those can go straight to code without triggering this skill.
---

# Engineer Design

## When This Skill Runs

Read the requirement — either from a requirement doc in `docs/requirement/` or from the user's description — along with any relevant existing code, then produce a **design brief**. The brief makes design decisions explicit before code makes them implicit.

**Input.** This skill expects the problem to be already understood. If a requirement doc exists at `docs/requirement/{slug}.md`, read it and use the same slug for the design brief. If the user describes the problem directly with enough clarity to make design decisions (concrete problem, clear scope, known constraints), that works too. If the requirement is vague — a sentence or two with no clear problem definition or scope — run the engineer-requirement skill first to clarify, rather than guessing at what the user needs.

Write the brief to `docs/design/{slug}.md`, where `{slug}` is the same kebab-case slug used in the requirement doc, or a short name for what the design achieves if there's no requirement doc.

**Revising an existing brief.** This skill also runs when implementation reveals that a Load-Bearing Decision, Interface, or the Data Model in an existing brief no longer holds. The brief is in `docs/implementation/` at that point — edit it in place rather than creating a new file. Apply the same rigor (compare alternatives if a genuine second option exists), update the affected sections directly, and record the discarded original choice under `## Alternatives Considered` so the history isn't lost.

When key information is missing — scale, constraints, existing interfaces, or which states and cases can actually occur — default to asking rather than assuming. That last category matters as much as the others: a design that quietly assumes a case is possible (or impossible) sends every downstream interface and error-handling decision in the wrong direction, and it's the kind of thing only the user can answer with confidence — code can't tell you what will never be called with what. Ask targeted questions (use the structured user-input tool when available and there are discrete options; otherwise ask concise plain-text questions) about anything that would change which design you'd pick, including what's actually reachable in production versus merely conceivable. Reserve stated assumptions in the brief for details that don't change the design's shape either way — an exact throughput number when only the order of magnitude matters, for instance. If you're unsure whether something is boundary-defining, that uncertainty is itself a reason to ask.

Before writing the brief, run cheap, reversible probes for critical unknowns when they can materially improve the design. Reading existing code, types, docs, and running existing tests is the cheapest way to answer a question — start there. When those don't settle it, write an actual spike: a throwaway script or prototype that exercises the real library, API, or data path to test one load-bearing assumption directly — does this library actually behave the way its docs claim, does this approach hit the latency budget, what does this endpoint actually return for the case that matters. A spike exists to answer exactly one question; build the smallest thing that answers it. Put spike code under `.scratchpad/{spike-name}/` in the current working directory, isolated from the real source tree. Leave it there once the question is answered — don't delete it unless the user explicitly asks; it's disposable but the user may still want to look at it. Keep persistent file changes, network calls, installs, and expensive benchmarks in the roadmap unless the user explicitly asks to run them now.

For each load-bearing decision, check whether a second approach exists that you'd genuinely be willing to defend — not a strawman built to lose. If one does, sketch and compare both before committing; comparing them is usually what surfaces the real trade-off, and the first idea is rarely the best one until something else exists to contrast it against. If the approach is obvious and no real alternative comes to mind, don't manufacture one — say so and move on.

**Approval gate.** Writing the brief is not the end of this skill — it's a checkpoint. Once the brief is written to disk, stop and ask the user to review it and approve — point to the file path and a short summary of the key decisions, don't re-paste the brief's contents into the conversation. Do not proceed to implementation until the user approves. If the user requests changes, revise the brief and ask again.

**After approval.** When the user approves, move the brief from `docs/design/{slug}.md` to `docs/implementation/{slug}.md`. This signals that the design is ready for implementation. Then stop — moving the file is the end of this skill's responsibility. Wait for the user to explicitly request implementation before writing any code. For brief revisions triggered mid-implementation: the file is already in `docs/implementation/` — edit it in place, pause and get approval on the updated section before resuming code changes.

## Design Brief Template

Keep the brief concise. Omit sections that add no decision value, and spend detail only on load-bearing choices.

```
## Problem
One sentence. What is being solved and for whom.
Link to requirement doc if one exists: `../requirement/{slug}.md`

## Scope
In: what this design covers.
Out: what it deliberately does not cover.

## Assumptions
Constraints and unknowns treated as given for this design.
Call out anything that, if wrong, would change the design significantly.
Include which input states or cases are guaranteed not to occur, not just
which ones are guaranteed to occur — that's what tells implementation
which cases don't need handling.

## Validation Findings
Cheap probes already run.
For each: question, method, result, design implication.
Omit this section when no probe was useful.

## Alternatives Considered
For each load-bearing decision: the road not taken and why it lost.
Omit only if there was genuinely one obvious approach.

## Components
Each component: name, single-sentence responsibility.
Aim for deep modules — simple interfaces hiding significant complexity.
Avoid components whose only job is to coordinate others.
Watch for a component whose method just calls another component's method
of the same name with no added logic — a sign the layering is wrong, not
that another abstraction is needed.

## Interfaces
For each non-trivial interface, write the signature + a short comment
describing it from the caller's perspective (what it does, what it returns,
what can go wrong). Say nothing about implementation.

If you can't write a clean 2–3 line comment without mentioning internals,
the boundary is wrong — reconsider the decomposition.

If two components' interfaces need to change together for most edits,
information is leaking across the boundary — merge them or move the
leaking piece to whichever side actually owns it.

Mark which interfaces sit at a trust boundary — the first point where
user input, external API responses, or other unvalidated data enters
the system — and state what gets validated there. Everything downstream
of that point should be able to rely on the guarantee without
re-checking it, so implementation has an authoritative answer instead
of having to guess where re-validation is actually needed.

## Data Model
Key entities, their relationships, ownership, and where they live.
Call out shared mutable state explicitly — it's the primary source of coupling.

## Load-Bearing Decisions
Decisions that are expensive to change once code exists
(schema, public contracts, sync vs. async, ownership boundaries).
For each: the choice made and the trade-off accepted.

## Risks / Open Questions
What's most likely to be wrong. How to find out early.
The riskiest assumption should become the first thing built or validated.

## Implementation Roadmap
Ordered sequence of steps to execute this design. Put the riskiest assumption first.
Each step should be independently buildable and verifiable.

For each step:
  - [area] action
  - Purpose: what this step proves or unlocks
  - Verification: how to know it worked

Example shape:
  - [ ] [risk validation] build the smallest slice that proves X
        Purpose: validate the riskiest assumption before committing to the full design
        Verification: run Y / observe Z
  - [ ] [core logic] implement the domain behavior behind the chosen interface
        Purpose: make the central behavior testable in isolation
        Verification: unit tests cover A and B
  - [ ] [integration] connect the core behavior to the existing system
        Purpose: expose the behavior through the real boundary
        Verification: integration test or manual flow confirms C
```

---

## Design Principles (Reference)

These inform how to fill in the brief. Apply judgment — not every section needs to invoke every principle.

**Control complexity above all else.** Complexity is anything that makes a system hard to understand or modify. It accumulates through dependencies (code that can't be understood in isolation) and obscurity (important information that isn't obvious). Good design contains complexity behind clean interfaces. Every structural decision should be evaluated by whether it reduces the complexity a future reader has to carry.

**Strategic over tactical.** Tactical programming solves the immediate problem with minimal effort and lets complexity accumulate as a side effect. Strategic programming treats each decision as an investment in long-term understandability. The time spent designing before coding is part of the work.

**Understand the problem before touching the solution.** State the problem in one sentence. If you can't, the design isn't ready. Identify what's actually needed vs. what was literally asked for — there's often a gap. Name what's out of scope; a design without a boundary is not a design.

**Deep modules over shallow ones.** A deep module has a simple interface relative to the complexity it hides. A shallow module has a complex interface relative to what it does — it adds cognitive load without absorbing it. Prefer fewer, deeper abstractions over many thin ones.

**Design interfaces from the call site.** Before thinking about implementation, write out how a component will be used. What does the caller provide? What do they get back? What can go wrong from their perspective? Minimize what crosses the boundary — every parameter and side effect is a contract and a source of cognitive load.

**Design it twice.** The first design that comes to mind is rarely the best one — it's just the first one. Sketch a genuinely different alternative for each load-bearing decision before picking. The point isn't to always reject the first idea; it's that you can't judge a design's weaknesses until you have a second one to contrast it against.

**Pull complexity downward.** When complexity can't be eliminated, the module should absorb it rather than pass it to every caller. A component with a slightly harder implementation and a simple interface beats one with an easy implementation that makes every caller handle edge cases, defaults, or retries themselves.

**Define errors and special cases out of existence.** Before designing an error path, ask whether the interface can be reshaped so the error can't occur — e.g. an operation that clamps or no-ops on an out-of-range input instead of throwing. Fewer special cases at the boundary means fewer things the caller has to get right.

**Model the domain first.** Data shape drives code shape. Model what the domain actually contains, then adapt UI and third-party API shapes at the boundary. Give each piece of data a clear owner; shared mutable state is the primary source of concurrency bugs and coupling.

**Identify load-bearing decisions early.** Some decisions are cheap to change; others require rewriting significant amounts of code once made (schema, public contracts, core ownership boundaries, fundamental architectural patterns). Focus design energy on the load-bearing ones; accept the rest as easy to revisit.

**Make trade-offs explicit.** Every design decision is a trade-off. State it: "We chose X over Y because Z." An implicit trade-off is a future surprise. If you're still designing in circles without new information, stop and build — code is often the fastest way to test a design assumption.
