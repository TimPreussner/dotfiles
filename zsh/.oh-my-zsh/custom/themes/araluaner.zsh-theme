function prompt_256_color() {
  echo "%{\e[38;5;${1}m%}"
}

BACKGROUND=$(prompt_256_color 39)  # blue
FOREGROUND=$(prompt_256_color 208) # orange

RETURN_CODE="%(?..─[ ${FOREGROUND}%?${BACKGROUND} ])"

ZSH_THEME_GIT_PROMPT_PREFIX="─[ ${FOREGROUND}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${BACKGROUND} ]"
ZSH_THEME_GIT_PROMPT_DIRTY=" ${BACKGROUND}[ ${FOREGROUND}✲${BACKGROUND} ]"
ZSH_THEME_GIT_PROMPT_CLEAN=""

if id -G -n | grep --quiet --word-regexp --regexp=sudo --regexp=admin --regexp=wheel; then
  ADMIN_INDICATOR='✓'
else
  ADMIN_INDICATOR='✗'
fi

ROOT_INDICATOR=""
if [[ $EUID -eq 0 ]]; then
  ROOT_INDICATOR="─[ ${FOREGROUND}!${BACKGROUND} ]"
fi

PROMPT=$'
${BACKGROUND}╭─[ ${FOREGROUND}%*${BACKGROUND} ]─[ ${FOREGROUND}%n@%m${BACKGROUND} [ ${FOREGROUND}${ADMIN_INDICATOR}${BACKGROUND} ] ]─[ ${FOREGROUND}%~${BACKGROUND} ]$(git_prompt_info)\
╰${RETURN_CODE}${ROOT_INDICATOR}─❯%{$reset_color%} '
