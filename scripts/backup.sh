#!/usr/bin/env bash
set -euo pipefail

cat >&2 <<'EOF'
backup.sh is reserved for STG/PRD operations.

The local dev environment uses disposable Docker volumes. For dev snapshots, use
Docker volume backup commands explicitly after deciding what data should be kept.
Production backup will be implemented after STG/PRD VMs are provisioned.
EOF
exit 1
