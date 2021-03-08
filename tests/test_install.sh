#!/bin/bash

# https://github.com/pgrange/bash_unit
#
#     assert "test -e /tmp/the_file"
#     assert_fails "grep this /tmp/the_file" "should not write 'this' in /tmp/the_file"
#     assert_status_code 25 code # 127: command not found; 126: command not executable
#     assert_equals "a string" "another string" "a string should be another string"
#     assert_not_equals "a string" "a string" "a string should be different from another string"
#     fake ps echo hello world

src_file="../install.sh"

test_script_execution_should_return_expected_status_code() {
    # script should be run with root privileges
    assert_status_code 1 "${src_file}"
}
