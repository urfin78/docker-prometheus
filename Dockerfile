ARG ARCH
ARG QEMU_ARCH
ARG GOLANG_ARCH
ARG SW_VERSION
FROM ${ARCH}/golang:1.12.9-buster as gobuild
ARG ARCH
ARG QEMU_ARCH
ARG GOLANG_ARCH
ARG SW_VERSION
ENV GOARCH ${GOLANG_ARCH}
ENV GOOS linux
COPY qemu-${QEMU_ARCH}-static /usr/bin/
WORKDIR ${GOPATH}/src
RUN git clone http://github.com/prometheus/prometheus.git --single-branch --branch ${SW_VERSION} --depth=1
WORKDIR ${GOPATH}/src/prometheus
RUN make build
FROM ${ARCH}/alpine
ARG QEMU_ARCH
COPY --from=gobuild /usr/bin/qemu-${QEMU_ARCH}-static /usr/bin/
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
RUN mkdir /data && chown -R ${UID}:${GID} /data
RUN rm -f /usr/bin/qemu-${QEMU_ARCH}-static
USER ${UID}:${GID}
EXPOSE 9090
ENTRYPOINT [ "/prometheus/prometheus", "--config.file=/prometheus/prometheus.yml"]
