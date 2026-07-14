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

Trust the types, the framework, and your own code's internal invariants. Validate only at system entry points: user input, external API responses, file contents. Inside the system, if a check is only there "to be safe," and the condition can't actually happen given the surrounding code — delete it. It adds noise and implies a contract that doesn't exist.

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
3. **Does this piece of code need to exist?** Apply to every line, check, abstraction, and parameter: if deleting it breaks nothing and clarifies nothing, delete it. If the type system or caller already prevents a failure, remove the handler. If an abstraction has no real second use case yet, inline it.
4. **Does solution complexity match problem complexity?** If the solution is much more complex, re-examine what problem you're actually solving.

## Testing Code

The principles above apply to test code at all levels — unit, integration, and end-to-end — with one important difference: **duplication in tests is usually fine.** Each test should be a self-contained story. Extracting shared setup into helpers can make individual tests harder to read in isolation — you have to jump around to reconstruct what's being tested.

Prefer inline, explicit test setup over shared helpers, unless the helper is genuinely about removing irrelevant noise (not about reusing logic). Three tests that each construct the same object from scratch are clearer than three tests that depend on a shared fixture whose defaults you have to remember.

Choose the right test level for the assertion: unit tests for pure logic, integration tests for boundaries between components or services, and end-to-end tests for user-facing flows. Over-mocking at the integration level is the same mistake as over-abstracting in production code — it couples the test to implementation details instead of behavior.
