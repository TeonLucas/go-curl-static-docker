# go-curl-static-docker
Statically linked libcurl example in Go language, deployed in an empty docker container

## Static linking for small containers
Go language is designed to readily build statically linked programs.  Such exectuables have no dependencies on the OS, and don't require the existance of any lib directories.  This is ideal for deploying a micro-service, resulting in smaller and more secure containers. Our sample App's Docker image is less than 6MB.

They easy way to link statically is to set the environment variable CGO_ENABLED=0 when building with Go.  However, there are times when you would like to use a C library, and thus cannot disable CGO.  You can still use C support in Go, and link with static libraries, as follows:
```sh
go build --ldflags '-extldflags "-static"'
```
This project is an example of:

1. Linking Libcurl statically
2. Compiling a sample curl app with Go
3. Deploying the app in an empty Docker container

## How to build
First, build the Go container:
```sh
./build-env.sh
```

To develop the App, modify [curl-app/main.go](https://raw.githubusercontent.com/DavidSantia/curl-app/main.go) as needed, and test it with:
```sh
go run curl-app/main.go
```

Then, deploy the App:
```sh
./build-app.sh
docker run --rm curl-app
```

If you want to log in to the golang container and compile manually, use:
```sh
docker run --rm -it -v $GOPATH:/home/app/go-lang golang-libcurl
```
* This gives you a sh prompt, as user "app"
* It also does a mount so you can access $GOPATH/src to compile code

### Docker Images
```
REPOSITORY                       TAG                 IMAGE ID            CREATED             SIZE
curl-app                         latest              b929c571c29e        5 minutes ago       5.54 MB
golang-libcurl                   latest              9ed651459978        19 minutes ago      421 MB
```
The two images that are built are as follows:
* **golang-libcurl** is the container for our build environement, which includes Go and our static libcurl.a
* **curl-app** is the container that deploys our sample curl app

### Notes
I chose the [golang:alpine](https://hub.docker.com/r/_/golang/) docker image because Alpine Linux uses MUSL for its C compiler, which is designed for efficient static builds.

I did not attempt to include LDAP, IDN or PSL support in Libcurl.  Expect the following warnings:
* configure: WARNING: Cannot find libraries for LDAP support: LDAP disabled
* configure: WARNING: Cannot find libraries for IDN support: IDN disabled
* configure: WARNING: libpsl was not found

The basic dependencies for libcurl are included, see the "apk add" step in [golang-libcurl/Dockerfile](https://raw.githubusercontent.com/DavidSantia/golang-libcurl/Dockerfile).

You will also see these warnings:
* /usr/include/sys/poll.h:1:2: warning: #warning redirecting incorrect #include <sys/poll.h> to <poll.h> [-Wcpp]
* configure: WARNING: Can not compare OpenSSL headers and library versions.

They seem to be just noise; Libcurl builds and works fine.

The sample **curl-app** uses the [go-curl](https://github.com/andelf/go-curl) library, Copyright 2014 Shuyu Wang (<andelf@gmail.com>)
