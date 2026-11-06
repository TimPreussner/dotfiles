#!/bin/bash

function status_256_color() {
  printf "\e[38;5;${1}m"
}

function make_bar() {
  local pct=${1:-0} width=$2 bar="" fill pad
  pct=${pct%.*}
  pct=${pct:-0}
  local filled=$(( (pct * width + 99) / 100 ))
  [ "$filled" -gt "$width" ] && filled=$width
  local empty=$((width - filled))
  [ "$filled" -gt 0 ] && printf -v fill "%${filled}s" && bar="${fill// /▓}"
  [ "$empty" -gt 0 ] && printf -v pad "%${empty}s" && bar="${bar}${pad// /░}"
  printf '%s' "$bar"
}

function usage_segment() {
  local key=$1 pct reset bar inner
  pct=$(echo "$INPUT" | jq -r ".rate_limits.${key}.used_percentage // empty")
  [ -z "$pct" ] && return
  reset=$(echo "$INPUT" | jq -r ".rate_limits.${key}.resets_at // empty")
  bar=$(make_bar "$pct" 10)
  inner="${FOREGROUND}${bar}${BACKGROUND} [ ${FOREGROUND}${pct%.*}%${BACKGROUND} ]"
  [ -n "$reset" ] && inner="${inner} [ ${FOREGROUND}$(date -r "$reset" '+%d.%m. %H:%M')${BACKGROUND} ]"
  printf '%s' "─[ ${inner} ]"
}

BACKGROUND=$(status_256_color 39) # blue
FOREGROUND=$(status_256_color 208) #orange

INPUT=$(cat)

DIR=$(echo "$INPUT" | jq -r '.workspace.project_dir')
GIT=""
if git -C "$DIR" rev-parse --is-inside-work-tree &>/dev/null; then
  GIT="─[ ${FOREGROUND}$(git -C "$DIR" branch --show-current || git -C "$DIR" rev-parse --short HEAD)${BACKGROUND} ]"
fi

echo "${BACKGROUND}╭─[ ${FOREGROUND}${DIR}${BACKGROUND} ]${GIT}"

CURRENT_DIR=$(echo "$INPUT" | jq -r '.workspace.current_dir')
if [ "$CURRENT_DIR" != "$DIR" ]; then
  CURRENT_GIT=""
  if git -C "$CURRENT_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
    CURRENT_GIT="─[ ${FOREGROUND}$(git -C "$CURRENT_DIR" branch --show-current || git -C "$CURRENT_DIR" rev-parse --short HEAD)${BACKGROUND} ]"
  fi
  echo "${BACKGROUND}├─[ ${FOREGROUND}${CURRENT_DIR}${BACKGROUND} ]${CURRENT_GIT}"
fi

MODEL=$(echo "$INPUT" | jq -r '.model.display_name')
EFFORT=$(echo "$INPUT" | jq -r '.effort.level')
CONTEXT_PCT=$(echo "$INPUT" | jq -r '.context_window.used_percentage // 0')
TOKENS=$(echo "$INPUT" | jq -r '.context_window.total_input_tokens // 0')
if [ "$TOKENS" -ge 1000 ]; then
  TOKENS_FMT="$((TOKENS / 1000)).$(( (TOKENS % 1000) / 100 ))k"
else
  TOKENS_FMT="$TOKENS"
fi

CONTEXT_BAR=$(make_bar "$CONTEXT_PCT" 20)

USAGE="$(usage_segment five_hour)$(usage_segment seven_day)"

echo "${BACKGROUND}╰─[ ${FOREGROUND}${MODEL}${BACKGROUND} [ ${FOREGROUND}${EFFORT}${BACKGROUND} ] ]─[ ${FOREGROUND}${CONTEXT_BAR}${BACKGROUND} [ ${FOREGROUND}${CONTEXT_PCT}%${BACKGROUND} ] [ ${FOREGROUND}${TOKENS_FMT}${BACKGROUND} ] ]${USAGE}"
