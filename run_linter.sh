#!/bin/bash

#/**
# * TangoMan shellcheck linter
# *
# * @license MIT
# * @author  "Matthias Morin" <mat@tangoman.io>
# */

function echo_title() {     echo -ne "\033[1;44;37m${*}\033[0m\n"; }
function echo_caption() {   echo -ne "\033[0;1;44m${*}\033[0m\n"; }
function echo_bold() {      echo -ne "\033[0;1;34m${*}\033[0m\n"; }
function echo_danger() {    echo -ne "\033[0;31m${*}\033[0m\n"; }
function echo_success() {   echo -ne "\033[0;32m${*}\033[0m\n"; }
function echo_warning() {   echo -ne "\033[0;33m${*}\033[0m\n"; }
function echo_secondary() { echo -ne "\033[0;34m${*}\033[0m\n"; }
function echo_info() {      echo -ne "\033[0;35m${*}\033[0m\n"; }
function echo_primary() {   echo -ne "\033[0;36m${*}\033[0m\n"; }
function echo_error() {     echo -ne "\033[0;1;31merror:\033[0;31m\t${*}\033[0m\n"; }
function echo_label() {     echo -ne "\033[0;1;32m${*}:\033[0m\t"; }
function echo_prompt() {    echo -ne "\033[0;36m${*}\033[0m "; }

clear

echo_title ' ############################## '
echo_title ' # TangoMan Shellcheck Linter # '
echo_title ' ############################## '
echo

if [ ! -x "$(command -v shellcheck)" ]; then
    echo_error "\"$(basename "${0}")\" requires shellcheck, try: 'sudo apt-get install -y shellcheck'"
    exit 1
fi

echo_info "find . -name '*.sh' | sort -t '\0' -n | xargs shellcheck"
find . -name '*.sh' | sort -t '\0' -n | xargs shellcheck

