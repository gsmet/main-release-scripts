#!/bin/bash
set -x -e

# GitHub releases are immutable once published so publishing the CLI is done in two steps:
# - release: creates a draft GitHub release with the CLI archives attached, before the release is published
# - publish: publishes the packages (SDKMAN, Homebrew, Chocolatey), after the release has been published
MODE="$1"
if [ "$MODE" != "release" ] && [ "$MODE" != "publish" ]; then
  echo "Mode required: release or publish"
  exit 1
fi

export VERSION=""
if [ -f work/newVersion ]; then
  VERSION=$(cat work/newVersion)
else 
  if [ $# -lt 2 ]
    then
      echo "Release version required, or 'work/newVersion' file"
      exit 1
  fi
  VERSION=$2
fi 

if [ -f work/branch ]; then
  BRANCH=$(cat work/branch)
else
  BRANCH="main"
fi

if [ -f work/maintenance ]; then
  MAINTENANCE="true"
else
  MAINTENANCE="false"
fi

if [ -f work/preview ]; then
  PREVIEW="true"
else
  PREVIEW="false"
fi

./work/quarkus/devtools/cli/distribution/release-cli.sh $VERSION $BRANCH $MAINTENANCE $PREVIEW $MODE

