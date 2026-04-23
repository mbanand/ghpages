# AGENTS.md

This file provides operational guidance for coding agents working in this
GitHub Pages article repository.

## Repository Purpose

This repository hosts static announcement articles and supporting assets,
starting with a Shinylive-based article for `shiny.webawesome`.

The repository is intentionally small and content-focused:

- article source files live in article subdirectories such as
  `announcement/`
- rendered static assets may be committed when they are part of the published
  site
- root-level site files control GitHub Pages behavior, such as redirecting the
  site root to a featured article

## Authoritative Documentation

Read these files before making changes:

```text
projectdocs/README.md
projectdocs/architecture/repository-structure.md
projectdocs/workflow/agent-development-playbook.md
```

If a task changes repository structure or publishing workflow, update the
relevant `projectdocs/` files first.

## Working Rules

1. Keep article URLs stable once they are shared externally.
2. Prefer adding new article directories rather than reshaping old paths.
3. Treat committed rendered assets as publishable site output, not disposable
   scratch artifacts.
4. Keep root-level GitHub Pages behavior simple and explicit.
5. Do not commit anything under `scratch/` or `journals/`.
6. Preserve any working browser-validation harnesses used to confirm live
   article behavior.

## Content and Publishing

- Each article should live in its own directory with its own `index.html`.
- The repository root may contain a redirecting `index.html` or a small landing
  page.
- Article-specific URLs such as `/post-name/` should remain valid even if the
  root redirect changes later.

## Validation Expectations

When article source or rendered assets change, run the relevant validation for
that article. Typical checks include:

- render the article
- serve it locally with a static server
- verify the page in a browser
- run any existing Playwright checks if present

## Scratch and Journals

- `scratch/` is for continuity notes and local planning artifacts only.
- `journals/` is for ignored session journals used to maintain workflow
  continuity across sessions.
