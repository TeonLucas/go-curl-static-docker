FROM golang:alpine

RUN adduser -D -g app app

RUN apk update && apk add --update curl curl-dev libcurl zlib-dev openssl-dev musl-dev gcc make perl pkgconf file

RUN cd /tmp; mkdir /usr/local/src; curl -LO http://curl.haxx.se/download/curl-7.47.1.tar.gz && \
    tar -C /usr/local/src -xzf curl-7.47.1.tar.gz; rm curl-7.47.1.tar.gz

RUN cd /usr/local/src/curl-7.47.1; \
    ./configure --disable-shared && \
    make && make install

# Create user
ENV HOME=/home/app
WORKDIR $HOME
USER app

RUN echo "export GOPATH=/home/app/go-lang" >> .profile && \
    echo "export PATH=$PATH:/usr/local/go/bin" >> .profile

CMD /bin/sh -l
