ARG JULIA_VERSION

FROM julia:${JULIA_VERSION}

ARG ORG
ARG PROJECT
ARG BRANCH
ARG ENTRYPOINT

ENV JULIA_THREADS=1

COPY ./init.jl /

########################################################
# Essential packages
########################################################

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    apt-utils gcc g++ openssh-server cmake build-essential gdb \
    gdbserver rsync vim locales git
RUN apt-get install -y bzip2 wget gnupg dirmngr apt-transport-https \
	tzdata ca-certificates openssh-server tmux && \
    apt-get clean

########################################################
# Ssh
########################################################

# Download public key for github.com
RUN mkdir -m 700 /root/.ssh; \
    touch -m 600 /root/.ssh/known_hosts; \
    ssh-keyscan github.com > /root/.ssh/known_hosts

########################################################
# Julia
########################################################

RUN --mount=type=ssh julia /init.jl && rm /init.jl

########################################################
# Clean up
########################################################

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

########################################################
# Download data
########################################################

ENTRYPOINT /run.sh