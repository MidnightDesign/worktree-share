# git-worktree-share

Automatically symlinks gitignored files (`.env`, local configs, etc.) into git worktrees.

## Convention

Put files you want shared across worktrees in `.git/share/` inside your repo:

```
your-repo/
  .git/
    share/
      .env
      .env.local
      any-other-ignored-file
```

That's it. New worktrees get symlinks to these files automatically. Existing worktrees can be updated with `wt-share`.

## Install

```bash
cd /path/to/git-worktree-share
bash install.sh
```

The script will offer to add `wt-share` to your PATH automatically.

## Usage

**New worktrees** — nothing to do. Files are symlinked automatically on `git worktree add`.

**Existing worktrees** — run from anywhere inside the repo:

```bash
wt-share
```

## How it works

- A global `post-checkout` hook detects when a linked worktree is created and symlinks every file from `.git/share/` into the worktree root.
- `wt-share` does the same thing retroactively for all existing linked worktrees.
- The `.git/` directory is shared across all worktrees, so the files in `share/` are always reachable regardless of which worktree you're in.
- Symlinks point to absolute paths inside `.git/`, so editing the file in one place updates it everywhere.
