---
name: engineer-design
description: Guide engineers through design before code for new feature design, module decomposition, architecture decisions, interface or data model design, and significant refactors. For small, well-scoped changes with a clear implementation path, proceed directly with implementation.
---

# Engineer Design

## When This Skill Runs

Read the requirements and any relevant existing code, then produce a **design brief** using the template below. The brief is the output of this skill — it makes design decisions explicit before code makes them implicit.

If key information is missing (scale, constraints, existing interfaces), state your assumptions explicitly in the brief rather than asking upfront. Ask only when an assumption would fundamentally change the design direction.

## Design Brief Template

Keep the brief concise. Omit sections that add no decision value, and spend detail only on load-bearing choices.

```
## Problem
One sentence. What is being solved and for whom.

## Scope
In: what this design covers.
Out: what it deliberately does not cover.

## Assumptions
Constraints and unknowns treated as given for this design.
Call out anything that, if wrong, would change the design significantly.

## Components
Each component: name, single-sentence responsibility.
Aim for deep modules — simple interfaces hiding significant complexity.
Avoid components whose only job is to coordinate others.

## Interfaces
For each non-trivial interface, write the signature + a short comment
describing it from the caller's perspective (what it does, what it returns,
what can go wrong). Say nothing about implementation.

If you can't write a clean 2–3 line comment without mentioning internals,
the boundary is wrong — reconsider the decomposition.

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

**Model the domain first.** Data shape drives code shape. Model what the domain actually contains, then adapt UI and third-party API shapes at the boundary. Give each piece of data a clear owner; shared mutable state is the primary source of concurrency bugs and coupling.

**Identify load-bearing decisions early.** Some decisions are cheap to change; others require rewriting significant amounts of code once made (schema, public contracts, core ownership boundaries, fundamental architectural patterns). Focus design energy on the load-bearing ones; accept the rest as easy to revisit.

**Make trade-offs explicit.** Every design decision is a trade-off. State it: "We chose X over Y because Z." An implicit trade-off is a future surprise. If you're still designing in circles without new information, stop and build — code is often the fastest way to test a design assumption.
