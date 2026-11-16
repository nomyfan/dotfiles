#!/bin/bash
set -f

input=$(cat)

if [ -z "$input" ]; then
    printf "Antigravity"
    exit 0
fi

# ── Theme detection ─────────────────────────────────────
is_light=false
if [ -n "$COLORFGBG" ]; then
    bg="${COLORFGBG##*;}"
    [ "$bg" -ge 0 ] 2>/dev/null && [ "$bg" -le 8 ] && is_light=true
elif [ "$(uname)" = "Darwin" ] && ! defaults read -g AppleInterfaceStyle &>/dev/null; then
    is_light=true
fi

# ── Colors ──────────────────────────────────────────────
if $is_light; then
    blue='\033[38;2;0;90;180m'
    orange='\033[38;2;190;110;0m'
    green='\033[38;2;0;130;55m'
    cyan='\033[38;2;0;120;140m'
    red='\033[38;2;200;40;40m'
    yellow='\033[38;2;170;140;0m'
    white='\033[38;2;80;80;80m'
    magenta='\033[38;2;120;70;210m'
else
    blue='\033[38;2;0;153;255m'
    orange='\033[38;2;255;176;85m'
    green='\033[38;2;0;175;80m'
    cyan='\033[38;2;86;182;194m'
    red='\033[38;2;255;85;85m'
    yellow='\033[38;2;230;200;0m'
    white='\033[38;2;220;220;220m'
    magenta='\033[38;2;180;140;255m'
fi
dim='\033[2m'
reset='\033[0m'

sep=" ${dim}│${reset} "

# ── Helpers ─────────────────────────────────────────────
format_tokens() {
    local num=${1:-0}
    if [ "$num" -ge 1000000 ] 2>/dev/null; then
        awk "BEGIN {printf \"%.1fm\", $num / 1000000}"
    elif [ "$num" -ge 1000 ] 2>/dev/null; then
        awk "BEGIN {printf \"%.1fk\", $num / 1000}"
    else
        printf "%d" "$num" 2>/dev/null || printf "0"
    fi
}

color_for_pct() {
    local pct=${1:-0}
    if [ "$pct" -ge 90 ] 2>/dev/null; then printf "$red"
    elif [ "$pct" -ge 70 ] 2>/dev/null; then printf "$yellow"
    elif [ "$pct" -ge 50 ] 2>/dev/null; then printf "$orange"
    else printf "$green"
    fi
}

build_bar() {
    local pct=${1:-0}
    local width=${2:-10}
    [ "$pct" -lt 0 ] 2>/dev/null && pct=0
    [ "$pct" -gt 100 ] 2>/dev/null && pct=100

    local filled=$(( pct * width / 100 ))
    local empty=$(( width - filled ))
    local bar_color
    bar_color=$(color_for_pct "$pct")

    local filled_str="" empty_str=""
    for ((i=0; i<filled; i++)); do filled_str+="▪"; done
    for ((i=0; i<empty; i++)); do empty_str+="▫"; done

    printf "${bar_color}${filled_str}${dim}${empty_str}${reset}"
}

# ── Extract JSON data (single jq pass) ──────────────────
eval "$(echo "$input" | jq -r '
  @sh "model_name=\(.model.display_name // .model.name // .model.id // "Antigravity")",
  @sh "effort=\(.model.effort // .effort.level // .thought_level // .effort_level // .reasoning_effort // "")",
  @sh "size=\((.context_window.context_window_size // 200000) | floor)",
  @sh "pct_used=\((.context_window.used_percentage // 0) | round)",
  @sh "pct_rem=\((.context_window.remaining_percentage // (100 - (.context_window.used_percentage // 0))) | round)",
  @sh "tot_in=\((.context_window.total_input_tokens // 0) | floor)",
  @sh "tot_out=\((.context_window.total_output_tokens // 0) | floor)",
  @sh "cur_in=\((.context_window.current_usage.input_tokens // 0) | floor)",
  @sh "cur_out=\((.context_window.current_usage.output_tokens // 0) | floor)",
  @sh "cache_create=\((.context_window.current_usage.cache_creation_input_tokens // 0) | floor)",
  @sh "cache_read=\((.context_window.current_usage.cache_read_input_tokens // 0) | floor)",
  @sh "total_usd=\(.cost.total_usd // "")",
  @sh "sub_usd=\(.cost.subagent_usd // "")",
  @sh "cwd=\(.workspace.current_dir // .cwd // "")",
  @sh "proj_dir=\(.workspace.project_dir // "")",
  @sh "vcs_branch=\(.vcs.branch // "")",
  @sh "vcs_dirty=\(if .vcs.dirty then "*" else "" end)",
  @sh "sandbox_enabled=\(if .sandbox.enabled == null then "" elif .sandbox.enabled then "true" else "false" end)",
  @sh "agent_state=\(.agent_state // "idle")",
  @sh "cycle_mode=\(.cycle_mode // "")",
  @sh "vim_mode=\(.vim.mode // "")",
  @sh "subagents=\((.subagents // 0) | if type == "array" then length else . end)",
  @sh "task_count=\(.task_count // 0)",
  @sh "artifact_count=\(.artifact_count // 0)"
' 2>/dev/null)"

[ "${size:-0}" -eq 0 ] 2>/dev/null && size=200000

current=$(( cur_in + cache_create + cache_read ))
if [ "$current" -eq 0 ] && [ "${pct_used:-0}" -gt 0 ]; then
    current=$(( size * pct_used / 100 ))
fi

used_tokens=$(format_tokens "$current")
total_tokens=$(format_tokens "$size")
pct_color=$(color_for_pct "$pct_used")

# ── Workspace & Git fallback ────────────────────────────
[ -z "$cwd" ] || [ "$cwd" = "null" ] && cwd=$(pwd)
dirname=$(basename "$cwd")
if [ -n "$proj_dir" ] && [ "$proj_dir" != "null" ] && [ "$proj_dir" != "$cwd" ]; then
    proj_name=$(basename "$proj_dir")
    dirname="${proj_name}/${dirname}"
fi

if [ -z "$vcs_branch" ] && git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    vcs_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
    if [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ]; then
        vcs_dirty="*"
    fi
fi

# ── LINE 1: Model │ Effort │ Context Bar │ Dir (branch*) │ Sandbox ──
line1="${blue}${model_name}${reset}"

if [ -n "$effort" ]; then
    line1+="${sep}"
    case "$effort" in
        max|xhigh) line1+="${magenta}◉ ${effort}${reset}" ;;
        high)      line1+="${magenta}● ${effort}${reset}" ;;
        medium)    line1+="${dim}◑ ${effort}${reset}" ;;
        low)       line1+="${dim}◔ ${effort}${reset}" ;;
        *)         line1+="${dim}◑ ${effort}${reset}" ;;
    esac
fi

line1+="${sep}"
ctx_bar=$(build_bar "$pct_used" 10)
line1+="${ctx_bar} ${pct_color}${used_tokens}${dim}/${reset}${pct_color}${total_tokens}${reset} ${dim}(${pct_used}%)${reset}"

line1+="${sep}"
line1+="${cyan}${dirname}${reset}"
if [ -n "$vcs_branch" ]; then
    line1+=" ${green}(${vcs_branch}${red}${vcs_dirty}${green})${reset}"
fi

if [ "$sandbox_enabled" = "true" ]; then
    line1+="${sep}${green}sandbox${reset}"
elif [ "$sandbox_enabled" = "false" ]; then
    line1+="${sep}${orange}no-sandbox${reset}"
fi

# ── LINE 2: State [mode] │ Vim │ Sub/Task/Art │ Tokens │ Cost ──
state_color="$white"
case "$agent_state" in
    working|tool_use|reviewing) state_color="$orange" ;;
    error)                      state_color="$red" ;;
    idle)                       state_color="$green" ;;
esac

line2="${state_color}${agent_state}${reset}"
if [ -n "$cycle_mode" ]; then
    line2+=" ${dim}[${cycle_mode}]${reset}"
fi

if [ -n "$vim_mode" ]; then
    line2+="${sep}${yellow}${vim_mode}${reset}"
fi

line2+="${sep}${dim}sub${reset} ${white}${subagents}${reset} ${dim}task${reset} ${white}${task_count}${reset} ${dim}art${reset} ${white}${artifact_count}${reset}"

tot_in_fmt=$(format_tokens "$tot_in")
tot_out_fmt=$(format_tokens "$tot_out")
cur_in_fmt=$(format_tokens "$cur_in")
cur_out_fmt=$(format_tokens "$cur_out")
cache_fmt=$(format_tokens "$cache_read")

line2+="${sep}${dim}in${reset} ${white}${tot_in_fmt}${reset} ${dim}out${reset} ${white}${tot_out_fmt}${reset}"
if [ "$cur_in" -gt 0 ] || [ "$cur_out" -gt 0 ] || [ "$cache_read" -gt 0 ]; then
    line2+=" ${dim}(cur ${cur_in_fmt}/${cur_out_fmt} cache ${cache_fmt})${reset}"
fi

if [ -n "$total_usd" ] && [ "$total_usd" != "null" ]; then
    cost_fmt=$(awk "BEGIN {printf \"%.3f\", $total_usd}")
    line2+="${sep}${white}\$${cost_fmt}${reset}"
    if [ -n "$sub_usd" ] && [ "$sub_usd" != "null" ] && awk "BEGIN {exit !($sub_usd > 0)}"; then
        sub_fmt=$(awk "BEGIN {printf \"%.3f\", $sub_usd}")
        line2+=" ${dim}(sub \$${sub_fmt})${reset}"
    fi
fi

printf "%b\n%b" "$line1" "$line2"
exit 0
