#!/bin/bash
#
# Builds VST3 for specified JUCE project.
#
# Volumes:
# - `/project-root`
# - `/outputs`
# - `/JUCE`

set -e

VOLUME_PROJECT_ROOT="/project-root"
VOLUME_OUTPUTS="/outputs"
VOLUME_JUCE="/JUCE"

git config --global --add safe.directory "${VOLUME_JUCE}"

juce_rev_actual="$(cd "${VOLUME_JUCE}" && git rev-parse HEAD)"

if [ "${juce_rev_actual}" != "${JUCE_REV_RECOMMENDED}" ]; then
  echo "warning: Recommended revision of JUCE is ${JUCE_REV_RECOMMENDED}, but actual is ${juce_rev_actual}" 1>&2
  echo 1>&2
fi

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

vst_path="$(find "${PWD}" -type d -name "*.vst3" | head -n 1)"
vst_name="$(basename "${vst_path}")"

vst_path_tmp="$(mktemp -d -q)"

# Prevent deletion of output when output folder mounted to itself:
cp -r "${vst_path}" "${vst_path_tmp}"

destination_path="${VOLUME_OUTPUTS}/${vst_name}"

rm -rf "${destination_path}"

cp -r "${vst_path_tmp}/" "${destination_path}"

ls -R "${VOLUME_OUTPUTS}"

echo "Build completed succefully:"
echo "${vst_name}"
echo
