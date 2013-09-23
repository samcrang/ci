#!/usr/bin/env bats

setup() {
  mkdir -p tmp
}

teardown() {
  rm -rf tmp
}

@test "when invoked without directory prints usage" {
  run bin/ci list
  [ "$status" -eq 1 ]
  [ $(expr "${lines[0]}" : "CI") -ne 0 ]
  [ $(expr "${lines[1]}" : "usage:") -ne 0 ]
}

@test "when invoked with a directory that does not exist should error" {
  run bin/ci list foo
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Directory 'foo' does not exist." ]
}

@test "should list all available projects in directory" {
  mkdir tmp/one
  mkdir tmp/two
  mkdir tmp/three
  touch tmp/one/run.sh
  touch tmp/two/run.sh
  run bin/ci list tmp
  [ "${lines[0]}" = "one" ]
  [ "${lines[1]}" = "two" ]
}
