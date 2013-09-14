#!/usr/bin/env bats

@test "no arguments prints usage" {
  run bin/ci
  [ "$status" -eq 1 ]
  [ $(expr "${lines[0]}" : "CI") -ne 0 ]
  [ $(expr "${lines[1]}" : "usage:") -ne 0 ]
}

@test "when invoked with a directory should run script" {
  run bin/ci tests/data/projects/simple
  [ "$status" -eq 0 ]
  [ "$output" = "SUCCESS" ]
}

@test "when invoked with a directory that does not exist should error" {
  run bin/ci foo 
  [ "$status" -eq 1 ]
  [ $(expr "${lines[0]}" : "Directory 'foo' does not exist.") -ne 0 ]
}

@test "when invoked with a directory that exists but does not contain a run.sh should error" {
  run bin/ci tests/data/projects/no_run_sh
  [ "$status" -eq 1 ]
  [ "$output" = "Cannot find run.sh" ]
}

@test "when invoked with a valid project that has a run.sh that fails should error" {
  run bin/ci tests/data/projects/failing_run_sh
  [ "$status" -eq 1 ]
  [ "$output" = "FAILURE" ]
}
