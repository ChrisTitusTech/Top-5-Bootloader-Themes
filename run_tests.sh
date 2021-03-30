#!/bin/bash

#/**
# * TangoMan Test Runner
# *
# * Runs tests in test directory with bash_unit
# *
# * @licence MIT
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

test_directory="$(realpath "$(pwd)")/tests"

clear

echo_title ' ######################## '
echo_title ' # TangoMan Test Runner # '
echo_title ' ######################## '
echo

if [ ! -d "${test_directory}" ]; then
    mkdir -p "${test_directory}"

    cat > "${test_directory}/test_bash.sh" <<EOF
#!/bin/bash

# https://github.com/pgrange/bash_unit
#
#     assert "test -e /tmp/the_file"
#     assert_fails "grep this /tmp/the_file" "should not write 'this' in /tmp/the_file"
#     assert_status_code 25 code
#     assert_equals "a string" "another string" "a string should be another string"
#     assert_not_equals "a string" "a string" "a string should be different from another string"
#     fake ps echo hello world

test_can_fail() {
    fail "You need to write some tests"
}
EOF
fi

if [ ! -f "${test_directory}/bash_unit" ]; then
    if [ -x "$(command -v wget)" ]; then
        echo_info "wget -qO \"${test_directory}/bash_unit\" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit"
        wget -qO "${test_directory}/bash_unit" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit

    elif [ -x "$(command -v curl)" ]; then
        echo_info "curl -sSL -o \"${test_directory}/bash_unit\" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit"
        curl -sSL -o "${test_directory}/bash_unit" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit

    else
        echo_error "could not find \"bash_unit\" executable, please install manually"
        exit 1
    fi
fi

if [ ! -x "${test_directory}/bash_unit" ]; then
    echo_info "chmod +x \"${test_directory}\"/bash_unit"
    chmod +x "${test_directory}"/bash_unit
fi

echo_info "cd \"${test_directory}\" || exit 1"
cd "${test_directory}" || exit 1

echo_info './bash_unit -f tap test_*'
./bash_unit -f tap test_*

