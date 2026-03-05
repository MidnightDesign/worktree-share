# worktree-share

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Stop copying `.env` files between worktrees.

`git worktree add` is great — until you realize your `.env`, `.env.local`, and other gitignored files didn't come with it. `worktree-share` fixes that by automatically symlinking them from a single source of truth into every worktree.

## Setup

Put the files you want shared in `.git/share/` inside your repo:

```
your-repo/
  .git/
    share/
      .env
      .env.local
```

That's it. Every new worktree gets symlinks to these files automatically.

## Install

```bash
cd /path/to/worktree-share
bash install.sh
```

The script installs a global `post-checkout` hook and offers to add `wt-share` to your PATH.

## Usage

**New worktrees** — nothing to do. Files are symlinked automatically on `git worktree add`.

**Existing worktrees** — run from anywhere inside the repo:

```bash
wt-share
```

## How it works

- A global `post-checkout` hook fires when a linked worktree is created and symlinks every file from `.git/share/` into the worktree root.
- `wt-share` does the same retroactively for all existing linked worktrees.
- `.git/` is shared across all worktrees, so `.git/share/` is always reachable from any of them.
- Symlinks use absolute paths, so editing a file in one worktree updates it everywhere.

## License

[MIT](LICENSE)
