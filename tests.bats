#!/usr/bin/env -S bats --tap

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

@test "ShellCheck check's out .bashrc.d/*.bash targets" {
    run shellcheck "${BATS_TEST_DIRNAME}/dot.files/.bashrc.d"/*.bash
    [ "$status" -eq 0 ]
}

@test "ShellCheck check's out .bashrc.d/.stdlib/*.bash targets" {
    # skip
    run shellcheck "${BATS_TEST_DIRNAME}/dot.files/.bashrc.d/.stdlib"/*.bash
    [ "$status" -eq 0 ]
}

@test "ShellCheck check's out .local/bin/*.bash targets" {
    # skip
    run shellcheck "${BATS_TEST_DIRNAME}/dot.files/.local/bin"/*.bash
    [ "$status" -eq 0 ]
}

@test "ShellCheck check's out .local/sbin/*.bash targets" {
    # skip
    run shellcheck "${BATS_TEST_DIRNAME}/dot.files/.local/sbin"/*.bash
    [ "$status" -eq 0 ]
}

