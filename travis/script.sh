#!/usr/bin/env bash
set -e
set -v
set -x

if [ ${ARCH} != "amd64" ];then
  QEMU_USER_STATIC_DOWNLOAD_URL="https://github.com/multiarch/qemu-user-static/releases/download"
  QEMU_USER_STATIC_LATEST_TAG=''
  while [ -z "${QEMU_USER_STATIC_LATEST_TAG}" ]
  do
      QEMU_USER_STATIC_LATEST_TAG=$(curl -s https://api.github.com/repos/multiarch/qemu-user-static/tags|grep 'name.*v[0-9]'| head -n 1| cut -d '"' -f 4)
  done
  curl -SL "${QEMU_USER_STATIC_DOWNLOAD_URL}/${QEMU_USER_STATIC_LATEST_TAG}/x86_64_qemu-${QEMU_ARCH}-static.tar.gz"|tar xzv
  docker run --rm --privileged multiarch/qemu-user-static:register --reset
fi

if [ ${VERSION} == "latest" ]; then
  export SW_VERSION=master
else
  export SW_VERSION=${VERSION}
fi
export DOCKERFILE="Dockerfile.${ARCH}"
docker build --build-arg GOLANG_ARCH=${GOARCH} --build-arg SW_VERSION=${SW_VERSION} --build-arg ARCH=${ARCH} --build-arg QEMU_ARCH=${QEMU_ARCH} -t urfin78/prometheus:${VERSION}-${ARCH} -f ${DOCKERFILE} .
