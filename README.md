# Executable Docker Image for lbstanza

This project contains a Dockerfile for creating a
stanza executable image. The idea is that this image
is used to run unit tests in github actions or other
CI implementations.

See https://github.com/StanzaOrg/lbstanza for more information
about `stanza`

## Example:

```
$> docker run -it --rm -v ./myproject:/project lbstanza:latest build
```

This will run `stanza build` on the project defined in `myproject`.
Note that the generated executables,etc probably won't run unless
your host environment matches the docker container environment
exactly. You are better off using either a script or a Makefile
to run the build and the tests simultaneously:

```
$> docker run -it --rm -v ./myproject:/project --entrypoint /usr/bin/make lbstanza:latest tests
stanza build
stanza build unit-tests
./unit-tests
[Test 1] some-test
[PASS]
...
```

If you are building a C wrapper around an existing library. You may need additional dependencies. If so, you are best off creating a new Dockerfile that uses this image as the base.

## Repl

You can run the repl and test things.

```
$> docker run -it --rm lbstanza:latest repl
stanza>
```

## Setup

1. First you will need a running docker implementation. You will probably also want to do [some setup to add your user to the `docker` group](https://docs.docker.com/engine/install/linux-postinstall/).
2. You will need to download the [`lbstanza` release package](http://lbstanza.org/downloads.html) that you want to deploy. Download the zip file and keep it in the local directory for the docker build.

## Build

```
$> docker build -t lbstanza:0.17.52 --build-arg lbstanza=lstanza_0_17_52.zip .
$> docker tag lbstanza:0.17.52 lbstanza:latest
```

This should create an image with the stanza compiler installed and accessible on the path.
