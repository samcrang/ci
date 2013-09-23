#!/usr/bin/env bats

setup() {
  mkdir -p tmp
}

teardown() {
  rm -rf tmp
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
