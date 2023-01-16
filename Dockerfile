FROM alpine as build

# First create a build image and copy the zip file
#  over. We then unpack that zip file so that we
#  can copy this to the deployed image without
#  needing to add a layer with the zip file in it.
USER root
ARG lbstanza=lstanza_0_17_53.zip
COPY $lbstanza /opt/

# @TODO - run bootstrap build here.

RUN mkdir -p /opt/temp && \
    unzip /opt/$lbstanza -d /opt/temp

# This is the output docker image
FROM alpine

ARG pkgs="build-base"

USER root
RUN apk add --update-cache $pkgs && rm -rf /var/cache/apk/*

RUN adduser -D -h /home/stanza -s /bin/ash stanza

RUN mkdir -p /opt/stanza /project && \
    chown stanza:stanza /opt/stanza /project

WORKDIR /opt/stanza
COPY --chown=stanza:stanza --from=build /opt/temp/ .
ENV PATH=${PATH}:/opt/stanza
USER stanza
# NOTE: This fails because the deployed stanza is not
#   setup to run on musl in alpine.
#RUN /opt/stanza/stanza install -platform linux

WORKDIR /project
ENTRYPOINT ["/opt/stanza/stanza"]
# Default to generate the help output if no
# args are given.
CMD ["help"]
