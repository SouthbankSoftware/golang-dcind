# Latest as of 20/05/2020.
FROM karlkfi/concourse-dcind@sha256:5a0703e28ceb901cc96d1ef5680d62ebb6cef6f5a907768dd34bc83fcccd5182

ARG GOLANG_VERSION=1.14.4
ARG CHECKSUM=7011af3bbc2ac108d1b82ea8abb87b2e63f78844f0259be20cde4d42c5c40584

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
