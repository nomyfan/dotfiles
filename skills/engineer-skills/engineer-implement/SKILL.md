---
name: engineer-implement
description: Guide coding agents to write minimal, correct, maintainable code with genuine engineering taste. Activate when completing the task involves creating or modifying code.
---

# Engineer Implement

The best code looks like it couldn't have been written any other way. Simplicity is a design achievement. Every line is a maintenance burden; the best line is often the one you deleted.

## The Mindset

A senior engineer asks different questions than a junior engineer:

| Junior asks | Senior asks |
|---|---|
| "How do I implement this?" | "What's the simplest design that's correct?" |
| "Does this work?" | "What will someone think reading this in 6 months?" |
| "What do I need to add?" | "What can I leave out?" |
| "How do I handle every edge case?" | "Which edge cases actually matter here?" |

Clever code is a liability. Clear code is an asset.

## Before Writing a Line

**State the problem precisely.** If you can't write one sentence describing what a function does, the design is wrong — not the description. Vague problem → speculative code.

**Find the simplest shape.** What's the smallest change to the system that produces the correct behavior? Work from that baseline. Every addition — a parameter, a branch, an abstraction — needs a concrete reason to exist.

**Design the API from the call site.** Code is read at the call site, not the implementation. Ask: what would the ideal interface look like to the caller? Then implement that. An interface that feels natural to use is usually also simpler to implement.

## Implementing From a Design Brief

When the task continues a `docs/specs/*.md` design brief, treat it as the plan, not gospel — designs are wrong more often than we'd like once they meet real code.

**Keep the roadmap current.** As each `Implementation Roadmap` step completes and its verification passes, check it off in the brief (`- [ ]` → `- [x]`). A roadmap that isn't updated is worse than no roadmap — it tells the next reader the wrong thing.

**Record deviations by severity, not by default.**
- *Minor* — an implementation detail differs from the brief, but the interfaces, data model, and trade-offs it described still hold. Add one line under a `## Deviations from Design` section at the end of the brief (create it if missing): what changed, why. Don't log things that don't change what a reader of the brief would believe.
- *Load-bearing* — the work reveals that an Interface, the Data Model, or a Load-Bearing Decision in the brief is actually wrong or unworkable. Don't quietly code around it. Stop and re-run the design skill against the existing brief to reconsider that decision — it updates the brief in place (including `## Alternatives Considered`), not you.

## The Dimensions of Quality

### Naming

Names compress intent. A good name makes the call site read like prose; a bad name forces the reader to trace back to the definition.

Name for what something *is*, not what operation produced it:

```
# Weak — describes the operation
filtered_users = filter_by_active_status(users)

# Strong — describes the concept
active_users = filter_by_active_status(users)
```

If you need to name something `data`, `result`, `info`, `temp`, or `manager` — the abstraction itself is unclear. The name is a symptom.

### Comments

Inside a function, comments carry the *why*; the code already carries the *what*. Restating the line below it is a second copy of the same information — and it goes stale the moment someone edits that line. Comment only what the reader can't infer: a non-obvious constraint, a workaround, a deliberate trade-off, a business rule.

Doc comments on a public API or an interface others implement are the exception — there the *what* is the contract, and callers shouldn't have to read the implementation to learn it: units, ownership, error and failure modes, side effects, thread-safety. State what a caller can't infer from the signature, and no more.

Either way, keep it short — one line when one line does it. A comment longer than the code it describes means either the code needs restructuring or most of the comment isn't earning its place. Don't reflexively docstring every small private helper, and don't narrate the edit (`// changed from X`, `// new helper`) — that's commit-message material.

### Structure

Code should tell a sequential story. The reader should follow one narrative, top to bottom, without jumping between functions to reconstruct intent. Watch for:

- **Ping-pong code**: understanding function A requires jumping to B, then C, then back to A
- **Premature extraction**: 5-line helper functions that are called once and obscure more than they clarify
- **Narrative breaks**: a function that does "setup, then the real work, then teardown" written as if all three are peers

The right size for a function is the size that matches one coherent responsibility — not a line-count target.

### Proportionality

Solution complexity should match problem complexity. If a simple problem has a complex solution, you're almost certainly solving the wrong problem. Ask: *am I adding complexity to the solution, or to the problem I think I have?*

Over-designed solutions are often symptoms of a misunderstood problem. Re-read the requirements before reaching for abstractions.

### Honesty

Functions do exactly what they're named. No hidden side effects. No surprising edge cases silently swallowed. No state modified as a "convenient" byproduct.

A function called `get_user` / `GetUser` / `getUser` that also logs, caches, fires metrics, and sometimes throws depending on environment is not a getter — it's a trap. Dishonest APIs cause bugs that take days to find.

### Working with the grain

Every language, framework, and codebase has a grain — the direction it was designed to be used. Idiomatic code works with that grain. Code that fights it is always harder to read, harder to debug, and usually slower.

Before introducing a pattern, ask: *does this codebase already have a way to do this?* Prefer the established pattern, even if your idea is "better."

## Key Judgment Calls

### When to abstract

Extract only when all three conditions hold:
1. Logic appears in 3+ genuinely equivalent places (same semantics, not just similar shape)
2. A change to one instance would require changing all of them
3. The abstraction has a name that's clearer than the inlined code

Two similar functions often *should* diverge. Abstracting them couples them artificially and makes both harder to change independently. Duplication is cheaper than the wrong abstraction.

### When to handle errors

Handle errors at the layer that has enough context to do something useful. Ask:
- Can this failure actually occur given the contracts and types I already have?
- Is this layer the right one to handle it, or should it propagate?
- Am I wrapping an error that already has a good message, just to feel safe?

Error handling that never executes is misleading — it implies failure modes that don't exist.

### When to add a parameter

Hard-code values until you have a concrete second use case with a different value. Parameters have a real cost: they make functions harder to read, call, test, and reason about. Pay that cost only when the need is demonstrated.

### When to add defensive checks

Trust the types, the framework, and your own code's internal invariants. Validate only at system entry points: user input, external API responses, file/DB reads, environment and config, and third-party code whose contract isn't enforced by the type checker. Once a value has crossed one of those boundaries and been checked, treat it as clean for the rest of its life — checking it again downstream doesn't add safety, it just buries the one check that matters among several that don't. If a design brief exists, its Interfaces and Assumptions sections should already say where these boundaries are and which states the system rules out — use that instead of re-deriving it from scratch.

The underlying test is always the same: can you name a specific guarantee — a type, a validated boundary, or a stated system invariant — that makes this check redundant? If you can, delete it. If you can't, or you're not sure, that uncertainty is the real signal — go find out (ask the user, check the design brief) rather than adding the check by default so it feels safe either way.

That test shows up in recurring shapes. Treat these as worked examples of the reasoning, not a checklist to clear and stop:
- **Origin already guarantees it.** A null/undefined check on a value the type system already marks as required, or re-validating a shape already validated at the boundary (e.g. checking an `id` looks like a string again three layers after the HTTP handler parsed it) — the guarantee exists upstream, so checking again is redundant, not extra-safe.
- **The failure mode can't occur.** A `try/catch` around a call that can't throw given its documented contract, or a `default:` branch on a switch/match the type system can already prove exhaustive — the honest answer to "what happens if this fires" is "nothing, it can't."
- **The state is conceivable but not reachable here.** A field that's always populated because every caller fills it in, a list that's never empty because it's built from a non-empty enum, a branch unreachable because upstream already routed that case elsewhere. This is the hardest one to catch — it doesn't read like a reflexive null check, it reads like careful engineering.

Plenty of over-defensive code fits the same test without matching any bullet above — a defensive copy guarding against mutation nobody actually performs, a retry wrapped around a call that doesn't fail transiently, a default for a parameter every existing caller already supplies. The question is never "does this match one of the examples" — it's "can I name the concrete guarantee this check would be redundant against."

Every defensive check makes an implicit claim: "this can actually go wrong here." When that claim is false, it costs the next reader real time — they now have to work out which checks in the file are load-bearing and which are noise, because nothing distinguishes them. That's the real cost of over-defensive code: not the extra lines, but the erosion of trust in every check that follows.

## What Senior Engineers Delete

The most impactful code review comment is often just "delete this."

- **Checks on conditions the caller already guarantees** — implies a false contract
- **Comments that restate what the code does** — `// increment counter` above `count++` is noise
- **Pass-through wrapper functions** — a function that does nothing but delegate to one other function with the same signature adds indirection without abstraction
- **Dead code kept "for reference"** — git remembers; your file shouldn't
- **Backwards-compat shims for code you own** — just update the callers
- **Speculative features and parameters** — "we might need this later" is the source of half the complexity in most codebases

**Exception: public APIs.** Before removing or renaming anything that external callers depend on — exported functions, REST endpoints, SDK interfaces, published types — confirm with the user. Breaking changes have a blast radius you can't see from the code alone.

## Self-Review: The Senior Engineer's Eye

Before submitting, read the diff as if you're seeing it for the first time:

1. **Can I state in one sentence what each function does?** If not, the problem is the structure, not the description — decompose.
2. **Does every name compress intent?** If a name could apply to many things, it's not doing its job.
3. **Does this piece of code need to exist?** Apply to every line, check, comment, abstraction, and parameter: if deleting it breaks nothing and clarifies nothing, delete it. Defensive checks are the most common offender here, especially ones guarding a case that's merely imaginable rather than actually reachable in this system — if the type system, caller, or the system's real invariants already prevent a failure, remove the handler. If an abstraction has no real second use case yet, inline it.
4. **Does solution complexity match problem complexity?** If the solution is much more complex, re-examine what problem you're actually solving.

## Testing Code

The principles above apply to test code at all levels — unit, integration, and end-to-end — with one important difference: **duplication in tests is usually fine.** Each test should be a self-contained story. Extracting shared setup into helpers can make individual tests harder to read in isolation — you have to jump around to reconstruct what's being tested.

Prefer inline, explicit test setup over shared helpers, unless the helper is genuinely about removing irrelevant noise (not about reusing logic). Three tests that each construct the same object from scratch are clearer than three tests that depend on a shared fixture whose defaults you have to remember.

Choose the right test level for the assertion: unit tests for pure logic, integration tests for boundaries between components or services, and end-to-end tests for user-facing flows. Over-mocking at the integration level is the same mistake as over-abstracting in production code — it couples the test to implementation details instead of behavior.
