FROM qnib/uplain-init

# Inspired by the official golang image
# > https://github.com/docker-library/golang/blob/132cd70768e3bc269902e4c7b579203f66dc9f64/1.8/Dockerfile

ARG LIBRDKAFKA_VER=0.11.0.x
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    bsdtar \
    ca-certificates \
    curl \
    dnsutils \
    g++ \
    gcc \
    git \
    libbind9-140 \
    libc6-dev \
    libseccomp-dev \
    librdkafka-dev \
    python \
    make \
    pkg-config \
    wget \
 && cd /usr/local/src/ \
 && echo "https://github.com/edenhill/librdkafka/archive/${LIBRDKAFKA_VER}.zip" \
 && wget -qO -  https://github.com/edenhill/librdkafka/archive/${LIBRDKAFKA_VER}.zip| bsdtar xzf - -C . \
 && cd librdkafka-${LIBRDKAFKA_VER} \
 && chmod +x configure lds-gen.py \
 && ./configure \
 && make \
 && make install \
 && rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.9rc2
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /usr/local/
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN curl -fsSL https://github.com/docker-library/golang/raw/132cd70768e3bc269902e4c7b579203f66dc9f64/1.8/go-wrapper -o /usr/local/bin/go-wrapper \
 && chmod +x /usr/local/bin/go-wrapper
RUN go get -u github.com/kardianos/govendor \
 && go get github.com/chouquette/coveraggregator
