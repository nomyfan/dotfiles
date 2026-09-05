---
name: engineer-review
description: Review engineering designs and code implementations for correctness, requirement fit, appropriate complexity, and code quality. Use when the user asks to review a design, implementation, diff, commit, or pull request. Routine self-checks while writing code do not require this skill.
---

# Engineer Review

Find problems worth fixing, explain why they matter, and support them with evidence. A review may legitimately find no actionable issues.

## Establish the Review Scope

Identify the artifact being reviewed and the relevant requirements, constraints, and accepted trade-offs from the request and available context.

- **Design review:** examine the proposal against requirements and the existing system.
- **Implementation review:** examine the requested code or diff, its callers, dependencies, and relevant tests. Use a design brief when available.
- **Combined review:** evaluate the design and implementation separately, then check whether the implementation preserves the intended contracts.

Use relevant requirement and design documents when available, including briefs in `docs/design/` or `docs/implementation/`. Their absence does not prevent reviewing a sufficiently clear request.

For change reviews, establish the comparison baseline. Distinguish introduced or worsened problems from unrelated pre-existing issues. Read enough surrounding context to assess behavior; do not restrict reasoning to changed lines. Keep findings within the requested scope.

Ask for clarification only when an unresolved ambiguity materially changes the review. Otherwise proceed and state relevant limitations.

The deliverable is the review report only. Keep the reviewer role read-only with respect to the reviewed artifacts: do not modify the design, implementation, or tests, or switch into implementation. Report findings and focused corrective suggestions without coordinating fixes or requiring a handoff workflow. Make the report self-contained so the user can share it with a separate design and implementation conversation.

## Standard for Findings

Before reporting a finding, establish:

1. The requirement, contract, or concrete maintenance concern involved.
2. A supported scenario or change in which the problem matters.
3. Evidence connecting the artifact to the consequence.
4. A focused corrective direction.

Trace suspected problems through relevant callers, types, validation, system invariants, and documented constraints. Actively look for evidence that disproves the concern before reporting it.

Distinguish observed facts from assumptions. An unresolved question is not a confirmed defect. If uncertainty prevents a conclusion, explain what needs to be verified and why it matters.

Do not report personal preferences as defects. A maintainability finding needs a concrete cost, such as duplicated business rules that can diverge, an interface that exposes internal state, or a change that requires coordinated edits across unrelated modules.

Engineering principles are judgment aids, not mechanical rules. Do not demand abstractions, defensive checks, alternative designs, or additional tests without a reason grounded in this system. Likewise, do not demand their removal without understanding the responsibility they serve.

## Reviewing a Design

Assess whether the proposal can satisfy the actual requirements and whether its important decisions are supported. Walk through concrete scenarios across components and interfaces.

Focus on the relevant questions:

- Do the proposed flows cover the required scenarios and success criteria?
- Are critical assumptions supported, or explicitly scheduled for validation?
- Are interfaces, data ownership, state transitions, and failure behavior coherent enough to implement?
- Do important decisions fit the existing system and stated constraints?
- Where applicable, are compatibility, migration, and rollout addressed?
- Does the roadmap test the riskiest assumptions early and provide meaningful verification?

### Is the Design Proportionate?

Evaluate whether the complexity fits current requirements, constraints, and supported expectations of change. A design can be over-engineered in one area and under-designed in another; assess individual decisions rather than labeling the entire proposal.

**Over-engineering:** identify mechanisms whose concrete benefits do not justify their implementation and maintenance costs. Examples include speculative extension points, configuration without a real variation, unnecessary distributed coordination, and layers that merely forward calls.

Ask: **If this mechanism were removed or merged, which established requirement or justified capability would be lost?** Consider the actual responsibility it serves; multiple layers or implementations are not inherently excessive. Recommend the simpler shape and explain what it still satisfies.

**Under-design:** identify necessary decisions that are missing or complexity that has been pushed onto callers without a coherent contract. Examples include shared state with no clear owner, retries with undefined duplicate-execution behavior, schema changes with no migration approach, and repeated caller-side handling of the same business rules.

Ask: **Would implementing this proposal require inventing a decision that materially affects correctness, public contracts, or architecture?** Explain the scenario that exposes the gap and the minimum decision or validation needed to close it.

Do not require implementation-level detail for decisions that can safely be deferred. Evaluate accepted trade-offs on their stated terms; challenge them when evidence undermines their assumptions. For each complexity finding, explain the design choice, its concrete cost or missing behavior, and how much simplification or additional design is sufficient.

## Reviewing an Implementation

Understand the intended behavior, then trace it through the affected paths.

### Acceptance Criteria

Check each applicable `Success Criteria` item in the requirement document, or the acceptance criteria explicitly established in the user's request. Use the design roadmap's `Verification` steps as verification methods, not as replacements for the required outcomes.

For each criterion, identify the relevant implementation and available evidence, then classify it as:

- **Satisfied:** sufficient evidence supports the required outcome; cite that evidence.
- **Not satisfied:** evidence shows the implementation fails the criterion; report the concrete mismatch as a finding.
- **Insufficient evidence:** the outcome cannot be established from the available review evidence; state what remains to be verified without presenting uncertainty as a confirmed defect.

Passing tests or checked roadmap steps alone do not establish acceptance. Assess whether they actually demonstrate the required behavior. If acceptance criteria are absent or ambiguous, state the limitation and seek clarification only when it materially affects the review; do not invent requirements. For a scoped change review, assess the affected criteria and make that coverage explicit.

### Correctness and Integration

Focus on the relevant risks:

- Incorrect results, broken contracts, or regressions in existing behavior.
- Mishandled state, ownership, concurrency, or resource lifetimes.
- Failures at input, persistence, and external-service boundaries.
- Compatibility or migration problems.
- Missing or misleading verification of behavior affected by the change.

Check the implementation against the requirements and design intent. A deviation is not automatically a defect: assess whether it is justified and whether important contracts still hold.

Use focused tests or small probes when they can resolve a material uncertainty. Report what was actually verified. Passing tests do not by themselves establish correctness. Report a test gap when a specific important behavior is unverified; do not demand tests merely because a file changed.

### Code Quality

Working code can still impose avoidable maintenance costs. Inspect for unnecessary complexity and implementation drift, including these recurring patterns:

- **Unnecessary code:** unused options, speculative extension points, redundant compatibility layers, and wrappers that only forward calls without serving a distinct responsibility.
- **Unsupported defensive handling:** repeated validation after an enforced boundary, branches for states excluded by actual invariants, and defaults or broad catches that hide failures. Verify the guarantee before recommending removal; a merely imagined guarantee is not evidence.
- **Fragmented flow and premature abstraction:** a simple operation scattered across helpers that obscure its sequence, or superficially similar logic coupled despite different semantics. Assess readability and responsibility, not function length or occurrence counts alone.
- **Drift from the codebase and task:** new utilities or patterns duplicating established ones, unnecessary dependencies, or unrelated refactoring that expands a focused change.
- **Unclear expression:** names that obscure business meaning, comments that repeat the code, or lengthy documentation that omits the actual contract. Explain the ambiguity or maintenance burden instead of policing wording.
- **Tests that prove little:** assertions that only repeat mock configuration or implementation details while leaving important behavior unverified.

These are prompts for investigation, not a checklist of mandatory findings. Do not call code defective because it appears AI-generated. Identify the specific construction, its actual cost, and a focused improvement. Prefer deletion or simplification when that preserves required behavior, but do not turn quality review into an unrelated rewrite.

## Report the Review

Lead with actionable findings, ordered by impact. Group multiple symptoms of the same root cause rather than repeating them.

For each finding, include:

- A short title describing the problem.
- A precise location: file and relevant lines, or document section.
- The triggering scenario, consequence, and supporting evidence.
- A focused correction or decision needed, without redesigning the entire solution.

Use priority according to consequence and urgency:

- **P0:** Immediate action required; a critical failure with established exposure.
- **P1:** Resolve before implementation or release, as applicable.
- **P2:** A material problem worth fixing, but not an immediate blocker.
- **P3:** A low-impact, actionable improvement.

Keep unresolved questions separate from confirmed findings. Keep optional suggestions separate and brief. Do not inflate severity or invent findings to meet a quota.

For implementation reviews, include a concise acceptance summary mapping each assessed criterion to its status and supporting evidence or verification gap. Reference findings rather than repeating their explanations.

End with a concise account of review coverage and material verification limits. If no actionable issues were found, say so explicitly without claiming the artifact is proven correct.
