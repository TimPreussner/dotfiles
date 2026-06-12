# path to oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# oh-my-zsh theme
ZSH_THEME="araluaner"

# make completion hyphen insensitive
HYPHEN_INSENSITIVE="true"

# update automatically every 10 days
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 10

# formatting for the history command
HIST_STAMPS="dd.mm.yyyy"

plugins=(
  colored-man-pages
  command-not-found
  copyfile
  copypath
  docker
  docker-compose
  git
  mvn
  pip
  ssh
)

source $ZSH/oh-my-zsh.sh

# use nano as default editor
export VISUAL='nano'
export EDITOR='nano'

# homebrew settings
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CASK_OPTS=--require-sha
export HOMEBREW_NO_INSECURE_REDIRECT=1
