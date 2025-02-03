#!/bin/bash

set -euo pipefail
set -x

error_message="$1"
itk_branch="$2"

git config --global --add safe.directory /github/workspace

cd "$GITHUB_WORKSPACE"

# Fetch the .clang-format file from the specified branch
wget https://raw.githubusercontent.com/InsightSoftwareConsortium/ITK/${itk_branch}/.clang-format -O /ITK.clang-format

if test $itk_branch = "master" -o $itk_branch = "main"; then
  # Use the same version of clang-format as used by ITK with its configuration
  wget https://raw.githubusercontent.com/InsightSoftwareConsortium/ITK/${itk_branch}/.pre-commit-config.yaml -O ./ITK.pre-commit-config.yaml
  clang_format_version=$(grep -A 1 "mirrors-clang-format" ./ITK.pre-commit-config.yaml | tail -n 1 | cut -d: -f2 | tr -d ' v')
  curl -fsSL https://pixi.sh/install.sh | bash
  export PATH=$HOME/.pixi/bin:$PATH
  pixi init --quiet
  pixi add python
  pixi add --pypi clang-format==$clang_format_version
  export PATH=$PWD/.pixi/envs/default/bin:$PATH
fi

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
