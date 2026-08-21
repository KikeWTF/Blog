# Contributing to the Project

> This document is addressed to **every person who touches this codebase** —
> human or AI agent. Read it fully before making any change. There are no
> exceptions.

This is a Quarto static blog. Read `agents.md` as well when it is present: it
is the living guide to the repository layout and development workflow.

---

## The golden rules

These rules are non-negotiable. Violating any of them will require the work to
be redone from scratch.

### 1. You never work on `main`

`main` is the stable, deployable trunk. It is not a scratch pad.

- **Never commit directly to `main`.**
- **Never push to `main` directly.**
- **Every single change**, no matter how small, goes on a dedicated branch
  first.

If you find yourself on `main` with uncommitted changes, stop. Stash them,
create a branch, and apply them there:

```bash
git stash
git checkout -b fix/my-accidental-change
git stash pop
```

### 2. You never merge without explicit consent

Merging into `main` is a deliberate, human-approved action. No branch is ever
merged automatically, speculatively, or "just to keep things tidy".

- **Wait for an explicit "merge this" instruction** before running any merge.
- When in doubt, ask. Do not assume.
- The only person who authorises a merge is the project lead.

When a merge is authorised, always use `--no-ff` so the branch topology is
preserved in the graph. The merge commit must also use the commit convention:

```bash
git checkout main
git merge --no-ff feat/my-feature -m "chore(site): merge my-feature branch"
```

### 3. Every commit and every branch must follow the naming convention

Consistency in naming makes the history readable at a glance. Deviating from
the convention makes the history noisy and harder to audit.

See [Branch naming](#branch-naming) and [Commit messages](#commit-messages)
for the full rules.

### 4. Render successfully before asking for a merge

Before asking for a merge, render the complete site locally:

```bash
quarto render
```

The command must complete successfully. When changing layout, styles, or
client-side reading tools, also inspect the rendered site in a browser at both
desktop and mobile widths. Fix any problem before requesting a merge.

---

## Branch naming

Branches follow the `type/short-description` pattern in **kebab-case**:

```text
feat/add-post
fix/markdown-image-export
chore/update-quarto
style/post-metadata-spacing
docs/repository-guide
```

| Prefix | When to use |
|---|---|
| `feat/` | New site capability or content feature |
| `fix/` | Bug fix |
| `chore/` | Maintenance, configuration, tooling, or deployment |
| `docs/` | Documentation only |
| `refactor/` | Restructure without behaviour change |
| `style/` | Styling or formatting change |

**Rules:**

- Use only lowercase letters, numbers, and hyphens. No slashes beyond the
  prefix.
- Keep descriptions short and specific (`fix/copy-markdown-images`, not
  `fix/stuff`).
- One concern per branch. If you need to do two unrelated things, open two
  branches.

---

## Commit messages

Follow [Conventional Commits](https://www.conventionalcommits.org/) strictly.
Every commit, including a merge commit, must have the format:

```text
type(scope): short imperative description

Optional body explaining *why*, not *what*.
```

The scope is mandatory. Never omit it.

The description must be in the imperative mood: use "add", "fix", or
"remove", not "added", "fixes", or "removing".

**AI agent rule:** Never append `Co-Authored-By` trailers to commit messages.

### Types

| Type | When to use |
|---|---|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `chore` | Maintenance, configuration, or tooling |
| `docs` | Documentation only |
| `refactor` | Restructure without behaviour change |
| `style` | Styling or whitespace |

### Valid examples

```text
feat(posts): add reverse engineering article
fix(markdown): export images with absolute URLs
chore(pages): enable GitHub Pages deployment
style(home): center listing titles
docs(agents): update repository guide
```

### Invalid examples

```text
fix stuff                         ← missing type and scope
feat(posts): Added an article     ← past tense; use "add"
update                            ← meaningless, no type, no scope
WIP                               ← never commit WIP to a shared branch
feat(site): fix styles and add post  ← separate unrelated concerns
```

---

## Workflow summary

```text
1. Start from an up-to-date main
   git checkout main && git pull

2. Create a dedicated branch
   git checkout -b feat/my-feature

3. Work and commit with meaningful Conventional Commit messages
   git commit -m "feat(scope): do something specific"

4. Validate the complete site
   quarto render

5. Push the branch and ask for an explicit merge approval
   git push origin feat/my-feature
```

Do not merge or push to `main` without explicit authorisation.
