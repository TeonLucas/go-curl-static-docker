#!/bin/sh

if [ -z $GOPATH ]; then
  echo "This script expects \$GOPATH to be set"
  exit
fi

PROJECT=src/github.com/DavidSantia/go-curl-static-docker/curl-app
if [ ! -d $GOPATH/$PROJECT ]; then
  echo "This script expects the project directory exist: $GOPATH/$PROJECT"
  exit
fi

IMAGE=`docker images -q golang-libcurl`
if [ -z $IMAGE ]; then
  echo "This script expects the Docker image golang-libcurl to be built"
  exit
fi

# Make the App
echo "Building Go executable for $GOPATH/$PROJECT"
docker run --rm --name golang-libcurl -v $GOPATH:/home/app/go-lang golang-libcurl /bin/sh -l -c \
    "cd go-lang/$PROJECT; go build --ldflags '-linkmode external -extldflags \"-static -lssh2 -lssl -lcrypto -lz\"'"

# Make the App deployment container
docker build -t curl-app curl-app
