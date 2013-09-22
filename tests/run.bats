#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p tmp
}

teardown() {
  rm -rf tmp
}

@test "when invoked with a directory should run script" {
  passing_run_sh
  run bin/ci run tmp/
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Pass" ]
  [ "${lines[1]}" = "SUCCESS" ]
}

@test "when invoked with a directory that does not exist should error" {
  run bin/ci run foo
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Directory 'foo' does not exist." ]
}

@test "when invoked with no directory should print usage" {
  run bin/ci run
  [ "$status" -eq 1 ]
  [ $(expr "${lines[0]}" : "CI") -ne 0 ]
  [ $(expr "${lines[1]}" : "usage:") -ne 0 ]
}

@test "when invoked with a directory that exists but does not contain a run.sh should error" {
  run bin/ci run tmp
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Cannot find run.sh" ]
  [ "${lines[1]}" = "FAILURE" ]
}

@test "when invoked with a valid project that has a run.sh that fails should error" {
  failing_run_sh
  run bin/ci run tmp
  [ "${lines[0]}" = "Fail" ]
  [ "${lines[1]}" = "FAILURE" ]
}

@test "when invoked with a valid project that has a run.sh that succeeds should execute teardown.sh" {
  passing_run_sh
  with_teardown
  run bin/ci run tmp
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Pass" ]
  [ "${lines[1]}" = "Tear down" ]
  [ "${lines[2]}" = "SUCCESS" ]
}

@test "when invoked with a valid project that has a run.sh that fails should execute teardown.sh" {
  failing_run_sh
  with_teardown
  run bin/ci run tmp
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Fail" ]
  [ "${lines[1]}" = "Tear down" ]
  [ "${lines[2]}" = "FAILURE" ]
}

@test "when a setup.sh is available should execute before run.sh" {
  passing_run_sh
  with_setup
  run bin/ci run tmp
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Setup" ]
  [ "${lines[1]}" = "Pass" ]
  [ "${lines[2]}" = "SUCCESS" ]
}

@test "when a setup.sh is available but a run.sh is not should return error" {
  with_setup
  run bin/ci run tmp
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Cannot find run.sh" ]
  [ "${lines[1]}" = "FAILURE" ]
}
