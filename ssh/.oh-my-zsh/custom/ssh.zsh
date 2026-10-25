ssh-keygen-yubikey() {
  if [[ $# -ne 2 || -z "$1" || -z "$2" ]]; then
    print -u2 "Usage: ssh-keygen-yubikey <application-name> <comment>"
    return 1
  fi

  ssh-keygen -t ed25519-sk \
    -O resident \
    -O verify-required \
    -O application="ssh:$1" \
    -C "$2"
}
