#!/usr/bin/env bash

passing_run_sh() {
  cat > tmp/run.sh <<EOF
#!/usr/bin/env bash
set -e

echo 'Pass'

exit 0
EOF
}

failing_run_sh() {
  cat > tmp/run.sh <<EOF
#!/usr/bin/env bash
set -e

echo 'Fail'

exit 1
EOF
}

slow_run_sh() {
  cat > tmp/run.sh <<EOF
#!/usr/bin/env bash
set -e
sleep 2
echo 'Pass'

exit 0
EOF
}

with_teardown() {
  cat > tmp/teardown.sh <<EOF
#!/usr/bin/env bash
set -e

echo "Tear down"
EOF
}
