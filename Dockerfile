FROM ubuntu as build

# First create a build image and copy the zip file
#  over. We then unpack that zip file so that we
#  can copy this to the deployed image without
#  needing to add a layer with the zip file in it.
USER root
ARG lbstanza=lstanza_0_17_53.zip
COPY $lbstanza /opt/
RUN apt update && apt install -y unzip && mkdir -p /opt/temp && \
    unzip /opt/$lbstanza -d /opt/temp

# This is the output docker image
FROM ubuntu

ARG pkgs="build-essential"

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends $pkgs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -U -s /bin/bash stanza

RUN mkdir -p /opt/stanza mkdir -p /project && \
    chown stanza:stanza /opt/stanza /project

WORKDIR /opt/stanza
COPY --chown=stanza:stanza --from=build /opt/temp/ .
ENV PATH=${PATH}:/opt/stanza
USER stanza
RUN /opt/stanza/stanza install -platform linux

WORKDIR /project
ENTRYPOINT ["/opt/stanza/stanza"]
# Default to generate the help output if no
# args are given.
CMD ["help"]
