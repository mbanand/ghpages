# Repository Structure

This repository is a lightweight static-site repo for published articles and
related assets.

## Top-Level Layout

```text
.
  index.html
  announcement/
  projectdocs/
  scratch/
  journals/
```

## Directory Roles

### `index.html`

The GitHub Pages site root entry point.

Initially this may redirect to a featured article such as `announcement/`.
Later it may become a small landing page that links to multiple article
directories.

### `announcement/`

The first article directory.

This directory may contain:

- source files such as `index.qmd`
- rendered output such as `index.html`, `index_files/`, and service worker
  files
- article-local validation helpers such as Playwright config or specs

Committed rendered assets in article directories are part of the published site
and should be treated as intentional outputs.

### `projectdocs/`

Minimal repository documentation for agents and maintainers.

### `scratch/`

Ignored workflow notes and continuity materials.

This directory is not part of the published site contract.

### `journals/`

Ignored session journals for development continuity.

This directory must remain uncommitted.

## URL Stability

Each article should keep a stable directory name once links are shared
externally. Future articles should be added as new sibling directories rather
than renaming prior paths.
