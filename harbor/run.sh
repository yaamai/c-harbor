#!/bin/bash

which docker
cp docker /usr/local/bin
which docker

cd src

for stg in compile build_base_docker build; do
  make $stg \
    -e VERSIONTAG=dev-amd64 \
    -e BASEIMAGETAG=dev-amd64 \
    -e PKGVERSIONTAG=dev-amd64 \
    -e CHARTFLAG=true \
    -e BUILDBIN=true \
    -e TRIVYFLAG=true
  docker images

  make $stg \
    -e VERSIONTAG=dev-arm64 \
    -e BASEIMAGETAG=dev-arm64 \
    -e PKGVERSIONTAG=dev-arm64 \
    -e CHARTFLAG=true \
    -e BUILDBIN=true \
    -e TRIVYFLAG=true \
    -e TRIVY_DOWNLOAD_URL=https://github.com/aquasecurity/trivy/releases/download/v0.11.0/trivy_0.11.0_Linux-ARM64.tar.gz 
  docker images
done

