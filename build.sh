#!/bin/bash
#
# Builds JUCE Framework project VST3 for Linux.

set -e

SOURCE_PATH="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

for arg in "$@"; do
  if [ "${arg}" == "-h" ] || [ "${arg}" == "--help" ]; then
    echo
    grep '^#.*' "${SOURCE_PATH}" | tail -n +3 | cut -c 3-
    echo
    echo "  Arguments (positional):"
    echo
    echo "      [project-root]     Your JUCE project directory path (relative to [cwd])."
    echo "      [jucer_project]    \`*.juce\` file path (relative to [project-root])."
    echo "      [juce_repo]        JUCE repository path (relative to [cwd])."
    echo "      [cwd]              Working directory."
    echo

    exit 0
  fi
done

project_root="$1"
jucer_project="$2"
juce_repo="$3"
cwd="$4"

docker run \
  --rm \
  --user "$(id -u):$(id -g)" \
  --mount "type=bind,source=${cwd}/${project_root},target=/project-root" \
  --mount "type=bind,source=${cwd}/${juce_repo},target=/JUCE" \
  --env "JUCER_PROJECT=${jucer_project}" \
  juce-build-linux:latest
