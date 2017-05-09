FROM qnib/uplain-init

# Inspired by the official golang image
# > https://github.com/docker-library/golang/blob/132cd70768e3bc269902e4c7b579203f66dc9f64/1.8/Dockerfile

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    g++ \
    gcc \
    git \
    libc6-dev \
    make \
    pkg-config \
 && rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.8
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 53ab94104ee3923e228a2cb2116e5e462ad3ebaeea06ff04463479d7f12d27ca

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /usr/local/
VOLUME ["/usr/local/src/"]
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

RUN curl -fsSL https://github.com/docker-library/golang/raw/132cd70768e3bc269902e4c7b579203f66dc9f64/1.8/go-wrapper -o /usr/local/bin/go-wrapper \
 && chmod +x /usr/local/bin/go-wrapper
RUN go get -u github.com/kardianos/govendor \
 && go get github.com/chouquette/coveraggregator
