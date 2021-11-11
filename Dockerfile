ARG JULIA_VERSION

FROM julia:${JULIA_VERSION}

ARG PACKAGE
ARG REPO=git@github.com:chipkent/${PACKAGE}.jl.git
ARG BRANCH=main

ENV JULIA_THREADS=1
ENV JULIA_PACKAGE=${PACKAGE}
ENV RUN_SCRIPT=docker_run.sh

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

RUN --mount=type=ssh \
    mkdir -p /root/.julia/dev/ && \
    git clone --branch=${BRANCH} ${REPO} /root/.julia/dev/${PACKAGE} && \
    julia -e "using Pkg; Pkg.activate(\"/root/.julia/dev/${PACKAGE}\"); Pkg.instantiate(); using ${PACKAGE}"

########################################################
# Clean up
########################################################

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

########################################################
# Download data
########################################################

ENTRYPOINT "/root/.julia/dev/${JULIA_PACKAGE}/scripts/${RUN_SCRIPT}"