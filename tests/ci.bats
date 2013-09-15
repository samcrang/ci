#!/usr/bin/env bats

@test "no arguments prints usage" {
  run bin/ci
  [ "$status" -eq 1 ]
  [ $(expr "${lines[0]}" : "CI") -ne 0 ]
  [ $(expr "${lines[1]}" : "usage:") -ne 0 ]
}

