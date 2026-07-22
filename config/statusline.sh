#!/usr/bin/env bash
# Claude Code status line: branch · model · context% · cost · tokens · rate limits
# Reads the session JSON on stdin (see `context_window`, `cost`, `effort`, `rate_limits` fields).
set -euo pipefail

input=$(cat)

# @tsv keeps empty fields as empty columns; `cut -f` preserves them (unlike `read`, which
# collapses tab-delimited empties because tab is IFS whitespace).
tsv=$(printf '%s' "$input" | jq -r '[
    (.model.display_name // "?"),
    (.effort.level // ""),
    (.context_window.used_percentage // ""),
    (.context_window.total_input_tokens // 0),
    (.context_window.context_window_size // 200000),
    (.cost.total_cost_usd // 0),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.five_hour.resets_at // ""),
    (.rate_limits.seven_day.used_percentage // ""),
    (.rate_limits.seven_day.resets_at // "")
] | @tsv')

model=$(printf '%s' "$tsv" | cut -f1)
effort=$(printf '%s' "$tsv" | cut -f2)
used_pct=$(printf '%s' "$tsv" | cut -f3)
in_tok=$(printf '%s' "$tsv" | cut -f4)
ctx_size=$(printf '%s' "$tsv" | cut -f5)
cost=$(printf '%s' "$tsv" | cut -f6)
fh_pct=$(printf '%s' "$tsv" | cut -f7)
fh_reset=$(printf '%s' "$tsv" | cut -f8)
sd_pct=$(printf '%s' "$tsv" | cut -f9)
sd_reset=$(printf '%s' "$tsv" | cut -f10)

cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // "."')
cd "$cwd" 2>/dev/null || true
branch=$(git branch --show-current 2>/dev/null || echo 'no-git')

# Context %: prefer the value Claude Code computes; otherwise derive from tokens.
if [[ -z "$used_pct" || "$used_pct" == "null" ]]; then
    used_pct=$(awk -v t="$in_tok" -v s="$ctx_size" 'BEGIN { printf "%d", (s > 0 ? t * 100 / s : 0) }')
else
    used_pct=$(awk -v p="$used_pct" 'BEGIN { printf "%d", p }')
fi

# green < 50, yellow 50-79, red >= 80
pct_color() {
    if   (( $1 >= 80 )); then printf '\033[31m'
    elif (( $1 >= 50 )); then printf '\033[33m'
    else                      printf '\033[32m'; fi
}

# seconds -> "Xd Yh" / "Xh Ym" / "Ym"
fmt_remaining() {
    local s=$1
    (( s < 0 )) && s=0
    local d=$(( s / 86400 )) h=$(( (s % 86400) / 3600 )) m=$(( (s % 3600) / 60 ))
    if   (( d > 0 )); then printf '%dd %dh' "$d" "$h"
    elif (( h > 0 )); then printf '%dh %dm' "$h" "$m"
    else                   printf '%dm' "$m"; fi
}

if   (( used_pct >= 80 )); then ctx_icon='🔴'
elif (( used_pct >= 50 )); then ctx_icon='🟡'
else                            ctx_icon='🧠'
fi
ctx_color=$(pct_color "$used_pct")

tok=$(awk -v t="$in_tok" 'BEGIN { if (t >= 1000) printf "%.1fk", t/1000; else printf "%d", t }')
cost=$(awk -v c="$cost" 'BEGIN { printf "$%.2f", c }')

dim='\033[2m'; cyan='\033[0;36m'; yellow='\033[0;33m'; reset='\033[0m'; sep="${dim} · ${reset}"
now=$(date +%s)

# Rate-limit segment: "<sep>icon label pct% (reset)" or nothing if the limit is absent.
rate_seg() {
    local icon=$1 label=$2 pct=$3 reset_at=$4
    [[ -z "$pct" || "$pct" == "null" ]] && return
    local p; p=$(awk -v x="$pct" 'BEGIN { printf "%.0f", x }')
    local seg="${sep}${icon} ${dim}${label}${reset} $(pct_color "$p")${p}%${reset}"
    if [[ -n "$reset_at" && "$reset_at" != "null" ]]; then
        seg="${seg} ${dim}($(fmt_remaining $(( reset_at - now ))))${reset}"
    fi
    printf '%s' "$seg"
}

model_seg="🤖 ${model}"
[[ -n "$effort" && "$effort" != "null" ]] && model_seg="${model_seg} ${dim}${effort}${reset}"

out="🌿 ${cyan}${branch}${reset}${sep}${model_seg}${sep}${ctx_icon} ${ctx_color}${used_pct}%${reset}${sep}💰 ${yellow}${cost}${reset}${sep}🪙 ${cyan}${tok}${reset}"
out="${out}$(rate_seg '⏳' '5h' "$fh_pct" "$fh_reset")"
out="${out}$(rate_seg '📅' 'wk' "$sd_pct" "$sd_reset")"

printf '%b' "$out"
