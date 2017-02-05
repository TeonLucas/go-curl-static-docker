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

# Make the Go build environment
docker build -t golang-libcurl golang-libcurl
