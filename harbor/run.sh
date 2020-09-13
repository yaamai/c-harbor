#!/bin/bash -ex

cred=$(echo $DOCKERCFG | python3 -c 'import sys,json; print(json.loads(sys.stdin.read())["https://registry-1.docker.io/v1/"]["auth"])' | base64 -d)

cd src

for stg in gen_apis compile build_base_docker build; do
  make $stg \
    -e REGISTRYUSER=$(echo $cred | cut -d: -f1) \
    -e REGISTRYPASSWORD=$(echo $cred | cut -d: -f2) \
    -e BASEIMAGENAMESPACE=yaamai \
    -e VERSIONTAG=dev-amd64 \
    -e BASEIMAGETAG=dev-amd64 \
    -e PKGVERSIONTAG=dev-amd64 \
    -e CHARTFLAG=true \
    -e BUILDBIN=true \
    -e TRIVYFLAG=true
  docker images

  # fix image name (makefile does not accept)
  docker tag goharbor/chartmuseum-photon:dev-amd64 yaamai/chartmuseum-photon:dev-amd64 || true
  docker tag goharbor/trivy-adapter-photon:dev-amd64 yaamai/trivy-adapter-photon:dev-amd64 || true
done

which docker
sudo cp ../docker /usr/local/bin || true
cp ../docker /usr/local/bin || true
which docker


for stg in gen_apis compile build_base_docker build; do
  make $stg \
    -e REGISTRYUSER=$(echo $cred | cut -d: -f1) \
    -e REGISTRYPASSWORD=$(echo $cred | cut -d: -f2) \
    -e BASEIMAGENAMESPACE=yaamai \
    -e VERSIONTAG=dev-arm64 \
    -e BASEIMAGETAG=dev-arm64 \
    -e PKGVERSIONTAG=dev-arm64 \
    -e CHARTFLAG=true \
    -e BUILDBIN=true \
    -e TRIVYFLAG=true \
    -e TRIVY_DOWNLOAD_URL=https://github.com/aquasecurity/trivy/releases/download/v0.11.0/trivy_0.11.0_Linux-ARM64.tar.gz 
  docker images

  # fix image name (makefile does not accept)
  docker tag goharbor/chartmuseum-photon:dev-arm64 yaamai/chartmuseum-photon:dev-arm64 || true
  docker tag goharbor/trivy-adapter-photon:dev-arm64 yaamai/trivy-adapter-photon:dev-arm64 || true
done

