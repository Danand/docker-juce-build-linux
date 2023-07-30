# `juce-build-linux`

Docker image that builds VST3 plugins for Linux written with JUCE Framework.

Image based on `debian:stable-slim` and contains all required dependencies to build project on JUCE Framework.

Currently recommended version of JUCE Framework is [7.0.5](https://github.com/juce-framework/JUCE/releases/tag/7.0.5)

## How to use

### Locally

```bash
git clone git@github.com:Danand/docker-juce-build-linux.git

cd docker-juce-build-linux

chmod +x ./build-vst3.sh

./build-vst3.sh \
  "relative-to-current-dir/my-project-dir" \
  "relative-to-my-project-dir/my-project.jucer" \
  "relative-to-current-dir/JUCE" \
  "." # Current dir.
```

### CI

```bash
docker login \
  --username "your-username" \
  --password "${GITHUB_TOKEN}" \
  ghcr.io

project_root="my-project-dir"
jucer_project="my-project.jucer"
juce_repo="JUCE"
outputs_dir="${project_root}/Builds/LinuxMakefile/build"
cwd="$(pwd)"

mkdir -p "${outputs_dir}"

docker run \
  --rm \
  --user "$(id -u):$(id -g)" \
  --mount "type=bind,source=${cwd}/${project_root},target=/project-root" \
  --mount "type=bind,source=${cwd}/${juce_repo},target=/JUCE" \
  --mount "type=bind,source=${cwd}/${outputs_dir},target=/outputs" \
  --env "JUCER_PROJECT=${jucer_project}" \
  ghcr.io/danand/docker-juce-build-linux/juce-build-linux:0.1.1
```
