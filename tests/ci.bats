#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p tmp
}

teardown() {
  rm -rf tmp
}

@test "no arguments prints usage" {
  run bin/ci
  [ "$status" -eq 1 ]
  [ $(expr "${lines[0]}" : "CI") -ne 0 ]
  [ $(expr "${lines[1]}" : "usage:") -ne 0 ]
}

@test "should be invokable from any directory" {
  cd tmp
  run ../bin/ci list ../examples
  [ "$status" -eq 0 ]
  [ $(expr "${lines[0]}" : "failing") -ne 0 ]
  [ $(expr "${lines[1]}" : "passing") -ne 0 ]
}
