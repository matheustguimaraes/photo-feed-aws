#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"
bash ecr-push-backend.sh
bash ecr-push-frontend.sh
