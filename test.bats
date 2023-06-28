#!/usr/bin/env bats

MODULE=module-name

setup() {
    DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)"
    BIN="$DIR/$MODULE"

    bats_require_minimum_version "1.5.0"

    bats_load_library bats-support
    bats_load_library bats-assert
}

@test "executable" {
    test -x $BIN
}

@test "ping" {
    run $BIN <(echo 'action=ping')
    assert_success --partial "pong"
}

@test "hello_world" {
    run $BIN <(echo 'action=hello_world')
    assert_success --partial "Hello, World!"

    run $BIN <(echo 'action=hello_world user_name=John')
    assert_success --partial "Hello, John!"
}

@test "failure" {
    run $BIN <(echo 'action=ls_dir')
    assert_failure
    assert_output --partial "\"failed\":true"
    assert_output --partial "missing arg: dir"

    run $BIN <(echo 'action=ls_dir dir=/tmp')
    assert_success
}
