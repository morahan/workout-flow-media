#!/usr/bin/env bash
# Source-control status matrix: branches, PRs, worktrees and stashes (local + remote) for one or more repos.
# Usage: git-status-matrix.sh [repo-dir ...]   (default: current repo)
set -uo pipefail

[ "$#" -eq 0 ] && set -- .
# Strip control chars (keep tab/newline) so PR titles or branch names can't inject terminal escapes
clean() { LC_ALL=C tr -d '\000-\010\013-\037\177'; }
has_gh=0; command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1 && has_gh=1

fmt='%-24s │ %6s %6s │ %6s │ %6s │ %6s │ %5s │ %-9s │ %s\n'
line() { printf '%s\n' '─────────────────────────┼───────────────┼────────┼────────┼────────┼───────┼───────────┼────'; }
printf "$fmt" '' 'branch' 'branch' 'PRs' 'work-' 'stash' 'dirty' 'main vs' ''
printf "$fmt" 'repo' 'local' 'remote' 'open' 'trees' 'local' 'files' 'origin' 'ok'
line

tl=0; tr=0; tp=0; tw=0; ts=0; td=0; all_ok=0; details=""
for dir in "$@"; do
  name="$(basename "$(cd "$dir" 2>/dev/null && pwd)")"
  if ! git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    printf '%-24s │ not a git repository\n' "$name"; all_ok=1; continue
  fi
  has_origin=0; git -C "$dir" remote get-url origin >/dev/null 2>&1 && has_origin=1
  fetched=0
  [ "$has_origin" = 1 ] && git -C "$dir" fetch --prune -q origin 2>/dev/null && fetched=1

  nl="$(git -C "$dir" for-each-ref refs/heads | wc -l | tr -d ' ')"
  nr="$(git -C "$dir" for-each-ref --format='%(refname)' refs/remotes | grep -vc '/HEAD$' | tr -d ' ')"
  wt="$(git -C "$dir" worktree list --porcelain | grep -c '^worktree ')"
  st="$(git -C "$dir" stash list | wc -l | tr -d ' ')"
  dirty="$(git -C "$dir" status --porcelain | wc -l | tr -d ' ')"

  prs=""; np="n/a"
  if [ "$has_origin" = 1 ] && [ "$has_gh" = 1 ]; then
    slug="$(git -C "$dir" remote get-url origin | sed -E 's#^(https://github.com/|git@github.com:)##; s#\.git$##')"
    if prs="$(gh pr list -R "$slug" --state open --limit 200 \
        --json number,headRefName,title,isDraft \
        --jq '.[] | "#\(.number) \(.headRefName)\(if .isDraft then " [draft]" else "" end) — \(.title)"' 2>/dev/null | clean)"; then
      np="$(printf '%s' "$prs" | grep -c . | tr -d ' ')"; tp=$((tp + np))
    else
      prs=""; np="err"
    fi
  fi

  if [ "$has_origin" = 1 ] && [ "$fetched" = 0 ]; then
    ab="fetch fail"   # remote refs may be stale, so don't compare against them
  elif [ "$has_origin" = 1 ]; then
    ab="$(git -C "$dir" rev-list --left-right --count main...origin/main 2>/dev/null | awk '{print "+"$1"/-"$2}')"
    ab="${ab:-n/a}"
  else
    ab="no remote"; nr="-"
  fi

  tl=$((tl + nl)); tw=$((tw + wt)); ts=$((ts + st)); td=$((td + dirty))
  [ "$nr" != "-" ] && tr=$((tr + nr))
  remote_ok=0; [ "$has_origin" = 1 ] && [ "$nr" = 1 ] && [ "$ab" = "+0/-0" ] && [ "$np" = 0 ] && remote_ok=1
  cur="$(git -C "$dir" symbolic-ref --short -q HEAD || echo "detached at $(git -C "$dir" rev-parse --short HEAD)")"
  if [ "$cur" = main ] && [ "$nl" = 1 ] && [ "$wt" = 1 ] && [ "$st" = 0 ] && [ "$dirty" = 0 ] && [ "$remote_ok" = 1 ]; then ok=✅; else ok=❌; all_ok=1; fi
  printf "$fmt" "$name" "$nl" "$nr" "$np" "$wt" "$st" "$dirty" "$ab" "$ok"

  # Per-repo detail, printed after the matrix
  d=""
  [ "$cur" != main ] && d+="  checkout: $cur (not main)"$'\n'
  extra_l="$(git -C "$dir" for-each-ref --format='%(refname:short)' refs/heads | grep -vx main)"
  extra_r="$(git -C "$dir" for-each-ref --format='%(refname:short)' refs/remotes | grep -v -E '^(origin|origin/HEAD|origin/main)$')"
  if [ -n "$extra_l$extra_r" ]; then
    d+="  branches (ahead/behind main):"$'\n'
    while IFS= read -r b; do
      [ -n "$b" ] || continue
      d+="$(printf '    %-8s %-50s %s' "$( [[ "$b" == origin/* ]] && echo remote || echo local)" "$b" \
        "$(git -C "$dir" rev-list --left-right --count "$b"...main 2>/dev/null | awk '{print "+"$1"/-"$2}')")"$'\n'
    done <<<"$extra_l"$'\n'"$extra_r"
  fi
  [ -n "$prs" ] && d+="  open PRs:"$'\n'"$(sed 's/^/    /' <<<"$prs")"$'\n'
  [ "$wt" -gt 1 ] && d+="  worktrees:"$'\n'"$(git -C "$dir" worktree list | sed 's/^/    /')"$'\n'
  [ "$st" -gt 0 ] && d+="  stashes:"$'\n'"$(git -C "$dir" stash list | sed 's/^/    /')"$'\n'
  [ "$dirty" -gt 0 ] && d+="  dirty files (first 15):"$'\n'"$(git -C "$dir" status --short | head -15 | sed 's/^/    /')"$'\n'
  [ -n "$d" ] && details+=$'\n'"── $name"$'\n'"$d"
done

if [ "$#" -gt 1 ]; then
  line
  printf "$fmt" 'TOTAL' "$tl" "$tr" "$tp" "$tw" "$ts" "$td" '' ''
fi
[ "$has_gh" = 0 ] && echo "(PRs n/a: gh CLI missing or not authenticated)"
printf '%s' "$details" | clean
echo
[ "$all_ok" -eq 0 ] && echo "main-only, clean and level with origin ✅" || echo "❌ = not on main, extra branches, PRs, worktrees, stashes, dirty files, main drift, failed fetch or no remote (details above)"
