FROM debian:stable-slim

WORKDIR /

RUN apt-get update && \
    apt-get install -y \
      git \
      make \
      g++ \
      libasound2-dev \
      libjack-jackd2-dev \
      ladspa-sdk \
      libcurl4-openssl-dev  \
      libfreetype6-dev \
      libx11-dev \
      libxcomposite-dev \
      libxcursor-dev \
      libxcursor-dev \
      libxext-dev \
      libxinerama-dev \
      libxrandr-dev \
      libxrender-dev \
      libwebkit2gtk-4.0-dev \
      libglu1-mesa-dev \
      mesa-common-dev

COPY ./build-image.sh .

RUN chmod +x ./build-image.sh

ENV JUCE_REV_RECOMMENDED "69795dc8e589a9eb5df251b6dd994859bf7b3fab"

ENTRYPOINT [ "./build-image.sh" ]
