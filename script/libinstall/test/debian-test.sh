#!/bin/bash

function oneTimeSetUp () {
  if [[ $EUID -ne 0 ]]; then
    echo "Tests must be run as root" 1>&2
    exit 1
  fi

  . $(dirname "$0")/../debian
  local username="$USER"


}

# function oneTimeTearDown () {
#   echo after
# }

function test_sourceLoaded () {
  # . "$0"/../debian
  assertEquals 'function' "$(type -t suc 2> /dev/null)"
}

function test_suc () {
  assertEquals 'test' "`suc 'echo test'`"
}

function test_update_apt_and_install_prerequirements_and_dependencies () {
  local required_packages=( ${PREREQUIRED_PACKAGES[@]} ${RUBY_REQUIRED_PACKAGES[@]} )
  required_packages=$(printf " %s" "${required_packages[@]}")
  required_packages=${required_packages:1}
  assertEquals 'git curl xz-utils gcc make zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev' "$required_packages"
}

# dpkg-query -Wf'${db:Status-abbrev}' libav-toolsgr 2>/dev/null | grep -q '^i'


. shunit2