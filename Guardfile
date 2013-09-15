guard :shell do
  watch('bin/ci') { `bats tests` }
  watch('tests/.*') { `bats tests` }
end
