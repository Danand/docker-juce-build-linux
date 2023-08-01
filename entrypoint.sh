#!/bin/bash
#
# Builds VST3 for specified JUCE project.
#
# Volumes:
# - `/project-root`
# - `/JUCE`

set -e

VOLUME_PROJECT_ROOT="/project-root"
VOLUME_JUCE="/JUCE"

echo "Starting to build ${JUCER_PROJECT}"
echo

echo "Current recommended revision of JUCE is ${JUCE_REV_RECOMMENDED}"
echo

cd "${VOLUME_PROJECT_ROOT}"

project_path="${PWD}/${JUCER_PROJECT}"

pushd "${VOLUME_JUCE}/extras/Projucer/Builds/LinuxMakefile"

make

pushd "build"

chmod +x ./Projucer

./Projucer \
  --resave "${project_path}" \
  --lf

popd
popd
pushd "./Builds/LinuxMakefile"

make VST3

ls -R "${VOLUME_OUTPUTS}"

echo "Build completed succefully"
echo
