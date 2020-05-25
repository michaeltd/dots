#!/usr/bin/env bats

source "${BATS_TEST_DIRNAME}/dot.files/.bashrc"

@test "Available Bash major version is greater or equal to 4" {
    run bash -c "echo ${BASH_VERSINFO[0]}"
    [ "$output" -ge "4" ]
}

@test "GNU Privacy Guard v2 executable is available in path" {
    run gpg --version
    [ "$status" -eq 0 ]
}

@test "OpenSSL executable is available in path" {
    run openssl version
    [ "$status" -eq 0 ]
}

@test "ShellCheck executable is available in path" {
    run shellcheck --version
    [ "$status" -eq 0 ]
}

@test "ShellCheck check's out .bashrc.d sources" {
    run shellcheck "${BATS_TEST_DIRNAME}/dot.files/.bashrc.d"/*
    [ "$status" -eq 0 ]
}
