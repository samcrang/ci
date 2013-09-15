#!/usr/bin/env bats

@test "when invoked with a directory should run script" {
  run bin/ci run tests/data/projects/passing_run_sh
  [ "$status" -eq 0 ]
  [ "$output" = "SUCCESS" ]
}

@test "when invoked with a directory that does not exist should error" {
  run bin/ci run foo
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Directory 'foo' does not exist." ]
  [ "${lines[1]}" = "FAILURE" ]
}

@test "when invoked with no directory should print usage" {
  run bin/ci run
  [ "$status" -eq 1 ]
  [ $(expr "${lines[0]}" : "CI") -ne 0 ]
  [ $(expr "${lines[1]}" : "usage:") -ne 0 ] 
}

@test "when invoked with a directory that exists but does not contain a run.sh should error" {
  run bin/ci run tests/data/projects/no_run_sh
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Cannot find run.sh" ]
  [ "${lines[1]}" = "FAILURE" ]
}

@test "when invoked with a valid project that has a run.sh that fails should error" {
  run bin/ci run tests/data/projects/failing_run_sh
  [ "$status" -eq 1 ]
  [ "$output" = "FAILURE" ]
}

@test "when invoked with a valid project that has a run.sh that succeeds should execute teardown.sh" {
  run bin/ci run tests/data/projects/tear_down_on_success
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Tear down" ]
  [ "${lines[1]}" = "SUCCESS" ]
}

@test "when invoked with a valid project that has a run.sh that fails should execute teardown.sh" {
  run bin/ci run tests/data/projects/tear_down_on_failure
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Tear down" ]
  [ "${lines[1]}" = "FAILURE" ]
}

@test "when a setup.sh is available should execute before run.sh" {
  run bin/ci run tests/data/projects/with_setup
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "Setup" ]
  [ "${lines[1]}" = "SUCCESS" ]
}

@test "when a setup.sh is available but a run.sh is not should return error" {
  run bin/ci run tests/data/projects/with_setup_no_run_sh
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Cannot find run.sh" ]
  [ "${lines[1]}" = "FAILURE" ]
}
