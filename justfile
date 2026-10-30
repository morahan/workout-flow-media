# Source-control matrix for this repo: local/remote branches, open PRs, worktrees, stashes, dirty files, main vs origin
status:
    @scripts/git-status-matrix.sh

# Publish the current branch through Git's normal configured hooks.
push:
    @git push
