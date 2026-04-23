# Agent Development Playbook

This playbook defines the expected workflow for work in this GitHub Pages
article repository.

## Core Principle

This repo exists to publish stable article URLs with minimal operational
complexity.

Prefer simple, durable site structure over clever build indirection.

## Typical Workflow

1. Read the continuity note in `scratch/` if relevant.
2. Read the latest journal entry if one exists.
3. Modify the source article or site-level files.
4. Re-render the affected article if needed.
5. Serve the site locally and verify behavior in a browser.
6. Run any available automated browser checks.
7. Keep publishable files committed and workflow-only files ignored.

## Publishing Shape

- Each article should have its own directory and `index.html`.
- The root `index.html` may redirect to the currently featured article.
- External submissions should usually use the article-specific URL rather than
  depending on the root redirect.

## Validation

When applicable, validate with:

- local render commands documented by the article
- a local static server
- browser inspection
- Playwright or other browser automation already present in the article

## Journals

When directed, write a session journal under `journals/`.

Journal contents should include:

- date and time
- tasks completed
- three proposed next steps
- a dedicated `Deferred items` section
- docs updated
- decisions made
- pitfalls and reminders

Always carry forward still-active deferred items from the prior journal.
