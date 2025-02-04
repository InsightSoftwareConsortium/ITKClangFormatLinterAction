#!/bin/bash

# Ignore the pipefail due to pixi failures set -euo pipefail

error_message="$1"
itk_branch="$2"

git config --global --add safe.directory /github/workspace

cd "$GITHUB_WORKSPACE"

if test $itk_branch = "master" -o $itk_branch = "main"; then
  # Use the same version of clang-format as used by ITK with its configuration
  wget https://raw.githubusercontent.com/InsightSoftwareConsortium/ITK/${itk_branch}/.pre-commit-config.yaml -O ./ITK.pre-commit-config.yaml
  clang_format_version=$(grep -A 1 "mirrors-clang-format" ./ITK.pre-commit-config.yaml | tail -n 1 | cut -d: -f2 | tr -d ' v')
  touch ${HOME}/.bashrc # The ~/.bashrc file must exist for pixi to initialize properly https://github.com/prefix-dev/pixi/pull/3051
  curl -fsSL https://pixi.sh/install.sh | bash
  export PATH=$HOME/.pixi/bin:$PATH
  echo "Starting pixi init"
  # NOTE: avoid requiring a terminal with --quiet --no-progress
  # NOTE: > /dev/null 2>&1 && echo "init completed" is to avoid error due to status writing failure during init
  pixi --quiet --no-progress init \
	  > /dev/null 2>&1 && echo "pixi init completed"
  echo "Adding python to pixi"
  pixi --quiet --no-progress add python \
	  > /dev/null 2>&1 && echo "pixi added python"
  echo "Adding clang-format from pypi"
  pixi --quiet --no-progress add --pypi clang-format==$clang_format_version \
	  > /dev/null 2>&1 && echo "clang-format==$clang_format_version added"
  export PATH=$PWD/.pixi/envs/default/bin:$PATH
fi

# If repo does not have private .clang-format, get the latest from ITK
if ! test -f ./.clang-format; then
  echo "Downloading ITK .clang-format from ${itk_branch}"
  # Fetch the .clang-format file from the specified branch
  wget https://raw.githubusercontent.com/InsightSoftwareConsortium/ITK/${itk_branch}/.clang-format -O /ITK.clang-format
  cp /ITK.clang-format ./.clang-format
fi

# Getting ITK branch version of clang-format.bash
echo "Downloading Utilities/Maintenance/clang-format.bash from ${itk_branch}"
wget https://raw.githubusercontent.com/InsightSoftwareConsortium/ITK/${itk_branch}/Utilities/Maintenance/clang-format.bash
chmod +x ./clang-format.bash

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
