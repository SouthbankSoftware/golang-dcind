# Latest as of 03/03/2019.
FROM karlkfi/concourse-dcind@sha256:e2bf5500e19804f42f0627076083ded9c41d1eca3486b8c7150a0ddde8ee274f

ARG GOLANG_VERSION=1.13.6
ARG CHECKSUM=aae5be954bdc40bcf8006eb77e8d8a5dde412722bc8effcdaf9772620d06420c

RUN apk add -q --no-progress --no-cache --virtual .build-deps gcc musl-dev openssl go && \
	export GOROOT_BOOTSTRAP=$(go env GOROOT) && \
	wget -O go.tgz "https://golang.org/dl/go${GOLANG_VERSION}.src.tar.gz" && \
	echo "${CHECKSUM} *go.tgz" | sha256sum -c - && \
	tar -C /usr/local -xzf go.tgz && \
	rm go.tgz && \
	(cd /usr/local/go/src && ./make.bash) && \
	rm -rf /usr/local/go/pkg/bootstrap /usr/local/go/pkg/obj && \
	apk del .build-deps && \
	/usr/local/go/bin/go version

ENV GOPATH=/go \
    PATH=/go/bin:/usr/local/go/bin:$PATH
