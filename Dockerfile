FROM golang:1.21.5-alpine as gobuild
ARG VERSION
WORKDIR ${GOPATH}/src
RUN apk add --no-cache yarn tar git curl bash build-base python3 npm
RUN git clone http://github.com/prometheus/prometheus.git --single-branch --branch ${VERSION} --depth=1
WORKDIR ${GOPATH}/src/prometheus
RUN make build
FROM alpine:3.18.4
ENV USER prometheus
ENV UID 9090
ENV GID 9090
RUN addgroup --gid "${GID}" "${USER}" \
    && adduser \
    --disabled-password \
    --gecos "" \
    --ingroup "${USER}" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"
COPY --from=gobuild --chown=${UID}:${GID} /go/src/prometheus/prometheus /prometheus/prometheus
COPY --from=gobuild --chown=${UID}:${GID} /go/src/prometheus/promtool /prometheus/promtool
COPY --from=gobuild --chown=${UID}:${GID} /go/src/prometheus/documentation/examples/prometheus.yml /prometheus/prometheus.yml
COPY --from=gobuild --chown=${UID}:${GID} /go/src/prometheus/LICENSE /prometheus/LICENSE
RUN mkdir /data && chown -R ${UID}:${GID} /data
USER ${UID}:${GID}
EXPOSE 9090
ENTRYPOINT [ "/prometheus/prometheus", "--config.file=/prometheus/prometheus.yml"]
