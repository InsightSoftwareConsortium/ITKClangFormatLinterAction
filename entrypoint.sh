#!/bin/bash

set -euo pipefail

error_message="$1"

cd "$GITHUB_WORKSPACE"

if ! test -f ./.clang-format; then
  cp /ITK.clang-format ./.clang-format
fi
/clang-format.bash --tracked
if ! git diff-index --diff-filter=M --quiet HEAD -- ':!.clang-format'; then
  echo "::error ::${error_message}"
  echo ""
  echo "Changes required:"
  echo ""
  echo "Files:"
  git diff-index --diff-filter=M --name-only HEAD -- ':!.clang-format'
  echo ""
  echo "Changes:"
  git diff HEAD -- ':!.clang-format'
  exit 1
fi
echo "clang-format ITK Coding Style check completed successfully."
