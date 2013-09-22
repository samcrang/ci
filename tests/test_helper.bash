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

with_teardown() {
  cat > tmp/teardown.sh <<EOF
#!/usr/bin/env bash
set -e

echo "Tear down"
EOF
}

with_setup() {
  cat > tmp/setup.sh <<EOF
#!/usr/bin/env bash
set -e

echo "Setup"
EOF
}
