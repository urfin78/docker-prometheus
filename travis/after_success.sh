#!/usr/bin/env bash

echo "${DOCKER_PW}" | docker login -u "${DOCKER_USER}" --password-stdin
docker push ${DOCKER_USER}/prometheus:${VERSION}-${ARCH}
docker manifest create ${DOCKER_USER}/prometheus:${VERSION} ${DOCKER_USER}/prometheus:${VERSION}-i386 ${DOCKER_USER}/prometheus:${VERSION}-arm32v6 ${DOCKER_USER}/prometheus:${VERSION}-amd64
docker manifest annotate --arch arm --os linux --variant v6 ${DOCKER_USER}/prometheus:${VERSION} ${DOCKER_USER}/prometheus:${VERSION}-arm32v6
docker manifest annotate --arch 386 --os linux ${DOCKER_USER}/prometheus:${VERSION} ${DOCKER_USER}/prometheus:${VERSION}-i386
docker manifest annotate --arch amd64 --os linux ${DOCKER_USER}/prometheus:${VERSION} ${DOCKER_USER}/prometheus:${VERSION}-amd64
docker manifest push ${DOCKER_USER}/prometheus:${VERSION}
