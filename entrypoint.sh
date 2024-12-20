#!/bin/bash

set -euo pipefail

error_message="$1"
itk_branch="$2"

git config --global --add safe.directory /github/workspace

cd "$GITHUB_WORKSPACE"

# Fetch the .clang-format file from the specified branch
wget https://raw.githubusercontent.com/InsightSoftwareConsortium/ITK/${itk_branch}/.clang-format -O /ITK.clang-format

wget https://raw.githubusercontent.com/InsightSoftwareConsortium/ITK/${itk_branch}/Utilities/Maintenance/clang-format.bash
chmod +x ./clang-format.bash

if ! test -f ./.clang-format; then
  cp /ITK.clang-format ./.clang-format
fi
./clang-format.bash --tracked
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
