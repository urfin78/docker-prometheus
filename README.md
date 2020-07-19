# Multiarch Docker Prometheus
![Docker image build and push](https://github.com/urfin78/docker-prometheus/workflows/Docker%20image%20build%20and%20push/badge.svg)
Build multiarch prometheus docker images.

Available variants:  
* linux/amd64
* linux/386

The Dockerfiles are build via Github actions and pushed to the [urfin78/prometheus](https://hub.docker.com/r/urfin78/prometheus) dockerhub repository.

You can manually build it by defining the prometheus version as build argument `SW_VERSION`.  
For the latest version use `master` as version.  

```bash
docker build --build-arg SW_VERSION=master -t prometheus -f Dockerfile.
```

## License
This code is distributed under [GPL v3.0 License](https://github.com/urfin78/docker-prometheus/blob/master/LICENSE).
Prometheus is distributed under [Apache License 2.0](https://github.com/prometheus/prometheus/blob/master/LICENSE).
