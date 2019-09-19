# Multiarch Docker Prometheus
[![Build Status](https://travis-ci.org/urfin78/docker-prometheus.svg?branch=master)](https://travis-ci.org/urfin78/docker-prometheus)
Build multiarch prometheus docker images.

The Dockerfiles are build via travis-ci.org, which pushes the images to the [urfin78/prometheus](https://hub.docker.com/r/urfin78/prometheus) dockerhub repository.

You can manually build the amd64 variant using the Dockerfile.amd64 and defining the Prometheus version as build argument `SW_VERSION`.
For the latest version use `master`as version.

```bash
docker build --build-arg SW_VERSION=master -t prometheus -f Dockerfile.amd64 .
```

## License
This code is distributed under [GPL v3.0 License](https://github.com/urfin78/docker-prometheus/blob/master/LICENSE).
Prometheus is distributed under [Apache License 2.0](https://github.com/prometheus/prometheus/blob/master/LICENSE).
