guard :shell do
  watch('bin/ci') { `bats tests | grep "^not ok"` }
  watch('tests/.*') { `bats tests | grep "^not ok"` }
end
