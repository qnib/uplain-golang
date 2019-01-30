ARG DOCKER_REGISTRY=docker.io
ARG FROM_IMG_REPO=qnib
ARG FROM_IMG_NAME=uplain-init
ARG FROM_IMG_TAG=bionic-20181112_2018-12-08.1
ARG FROM_IMG_HASH=""

FROM ${DOCKER_REGISTRY}/${FROM_IMG_REPO}/${FROM_IMG_NAME}:${FROM_IMG_TAG}${DOCKER_IMG_HASH}

# Inspired by the official golang image
# > https://github.com/docker-library/golang/blob/132cd70768e3bc269902e4c7b579203f66dc9f64/1.8/Dockerfile
RUN apt-get update -qq \
 && apt-get install -y -qq wget ca-certificates gnupg2 \
 && wget -qO - https://packages.confluent.io/deb/5.1/archive.key | apt-key add - \
 && echo ""deb [arch=amd64] https://packages.confluent.io/deb/5.1 stable main"" > /etc/apt/sources.list.d/confluent.list \
 && apt-get update -qq \
 && apt-get install -qq -y --no-install-recommends \
    ca-certificates \
    curl \
    dnsutils \
    gcc \
    git \
    pkg-config \
    libc6-dev \
    libseccomp-dev \
    librdkafka-dev

ARG GOLANG_VERSION=1.11.5
ARG GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOPATH /usr/local/
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" | tar xfz - -C /usr/local \
 && mkdir -p "$GOPATH/src" "$GOPATH/bin" \
 && chmod -R 777 "$GOPATH" \
 && go get -u github.com/kardianos/govendor \
 && go get github.com/chouquette/coveraggregator \
 && go get -u github.com/golang/lint/golint
