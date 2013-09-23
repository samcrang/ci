#!/usr/bin/env bats

setup() {
  mkdir -p tmp
}

teardown() {
  rm -rf tmp
}

@test "when invoked without directory prints usage" {
  run bin/ci init
  [ "$status" -eq 1 ]
  [ $(expr "${lines[0]}" : "CI") -ne 0 ]
  [ $(expr "${lines[1]}" : "usage:") -ne 0 ]
}

@test "when invoked with a directory that does not exist should error" {
  run bin/ci init foo
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Directory 'foo' does not exist." ]
}

@test "when invoked with a valid directory should create empty scripts" {
  run bin/ci init tmp
  [ "$status" -eq 0 ]
  [ `wc -c tmp/setup.sh | awk '{print $1}'` -gt 0 ]
  [ `wc -c tmp/run.sh | awk '{print $1}'` -gt 0 ]
  [ `wc -c tmp/teardown.sh | awk '{print $1}'` -gt 0 ]
  [ `wc -c tmp/trigger.sh | awk '{print $1}'` -gt 0 ]
}

@test "when invoked with a valid directory should not overrwrite files if they already exist" {
  touch "tmp/setup.sh"
  run bin/ci init tmp
  [ "$status" -eq 0 ]
  [ `wc -c tmp/setup.sh | awk '{print $1}'` -eq 0 ]
}
