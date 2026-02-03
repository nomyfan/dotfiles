---
name: commit-please
description: Intelligent git commit assistant that analyzes staged and unstaged changes in the current working directory, generates commit messages following Conventional Commits specification (conventionalcommits.org), and executes commits after user approval. Use when the user asks to create a commit, wants help writing a commit message, or says "commit these changes" or similar requests.
---

# Commit Please

## Overview

This skill helps create well-crafted git commits following the Conventional Commits specification. It analyzes changes in the working directory, generates meaningful commit messages, and executes the commit after user approval.

## Workflow

Follow these steps in order:

### 1. Analyze the Repository State

Run these git commands to understand what changes will be committed:

```bash
git status
git diff --staged
git diff
```

**Important notes:**
- NEVER use the `-uall` flag with git status (can cause memory issues on large repos)
- Review both staged and unstaged changes to understand the full context
- Pay attention to new files, modified files, and deleted files

### 2. Generate the Commit Message

Generate a commit message following the **Conventional Commits specification** (https://www.conventionalcommits.org/en/v1.0.0/).

**Format:**
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types (choose the most appropriate):**
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that don't affect code meaning (formatting, whitespace, etc.)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Performance improvement
- `test`: Adding or updating tests
- `build`: Changes to build system or dependencies
- `ci`: Changes to CI configuration files and scripts
- `chore`: Other changes that don't modify src or test files
- `revert`: Reverts a previous commit

**Scope (optional but recommended):**
- A noun describing the section of codebase (e.g., `parser`, `api`, `auth`, `ui`)
- Use when changes are localized to a specific component or module

**Description:**
- Use imperative mood ("add" not "added" or "adds")
- Don't capitalize first letter
- No period at the end
- Be clear and concise (50-72 characters recommended)

**Body (optional):**
- Provide additional context about the changes
- Explain the "why" not the "what"
- Leave a blank line after the description
- Wrap at 72 characters

**Footer (optional):**
- Reference issues: `Fixes #123`, `Closes #456`
- Breaking changes: `BREAKING CHANGE: <description>`

**Breaking changes:**
- Place an exclamation mark after type/scope: `feat(api)!: remove deprecated endpoints`
- Or use BREAKING CHANGE footer: `BREAKING CHANGE: removed support for Node 12`

**Examples:**

```
feat(auth): add JWT token refresh mechanism
```

```
fix(api): prevent memory leak in request handler

The handler was not properly disposing of buffer allocations
after processing requests, causing memory to grow over time.

Fixes #234
```

```
feat(ui)!: redesign navigation component

BREAKING CHANGE: Navigation props have changed. The `items` prop
now expects an array of objects instead of strings.
```

```
refactor(database): migrate to async/await pattern

- Replace callback-based queries with promises
- Add proper error handling for connection failures
- Update all tests to match new async patterns
```

```
chore(deps): update typescript to 5.0
```

### 3. Present Message for Approval

Show the generated commit message to the user clearly and ask for approval. Use the AskUserQuestion tool with options like:
- "Approve and commit" (recommended option)
- "Suggest edits"
- "Cancel"

**Example presentation:**
```
I've analyzed the changes and generated this commit message following Conventional Commits:

---
feat(profile): add user avatar upload functionality
---

Would you like me to proceed with this commit message?
```

### 4. Handle User Response

**If approved:** Execute the commit using:
```bash
git commit -m "$(cat <<'EOF'
[commit message here]
EOF
)"
```

**If edits requested:**
- Ask the user what they'd like to change
- Regenerate the message incorporating their feedback
- Present again for approval

**If cancelled:**
- Acknowledge and end the workflow
- No commit should be executed

### 5. Confirm Success

After executing the commit, run `git log -1` to confirm the commit was created successfully and show the user the commit details.

## Important Constraints

**DO NOT:**
- Commit without explicit user approval
- Stage or unstage files unless explicitly requested
- Push changes to remote (unless separately requested)
- Amend commits or use other git flags unless explicitly requested
- Make assumptions about what should be staged
- Include `Co-Authored-By` or any co-author information in the commit message unless the user explicitly requests it

**DO:**
- Follow Conventional Commits specification strictly
- Choose the most accurate type based on the changes
- Add scope when changes are localized to a specific area
- Only commit changes that are currently staged (or stage files if user requests)
- Check `git log` to see if the repository uses specific scope conventions
- Ask clarifying questions if the changes are unclear or seem unrelated
- Recommend splitting changes into multiple commits if they address different concerns
