claude-cmd() {
  local prompt="$*"
  if [ -z "$prompt" ]; then
    printf 'what should the command do? '
    read -r prompt
  fi
  while [ -n "$prompt" ]; do
    local cmd
    cmd=$(claude -p "Output ONLY a single bash command that does the following. No prose, no markdown, no code fences. Task: $prompt")
    cmd=$(printf '%s' "$cmd" | sed -E 's/^```[a-zA-Z]*$//; s/^```$//' | sed '/^[[:space:]]*$/d')
    printf '\n  $ %s\n\n' "$cmd"
    printf '[enter] to run, or describe a refinement (Ctrl+C to exit): '
    read -r prompt
    [ -z "$prompt" ] && { eval "$cmd"; return $?; }
  done
}
