ARG JULIA_VERSION

FROM julia:${JULIA_VERSION}

ARG REPO
ARG BRANCH
ARG ENTRYPOINT

ENV JULIA_THREADS=1
ENV RUN_SCRIPT=${ENTRYPOINT}

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
    # julia -e "using Pkg; Pkg.develop(Pkg.PackageSpec(url=\"${REPO}\", rev=\"${BRANCH}\")); for package in readdir(\"/root/.julia/dev/\"); Pkg.activate(\"/root/.julia/dev/$package\"); Pkg.instantiate(); end;"
    # julia -e "using Pkg; Pkg.develop(\"${REPO}@${BRANCH}\")); for package in readdir(\"/root/.julia/dev/\"); Pkg.activate(\"/root/.julia/dev/$package\"); Pkg.instantiate(); end;"
    julia -e "using Pkg; Pkg.develop(\"${REPO}\")"
    # julia -e "using Pkg; Pkg.develop(Pkg.PackageSpec(url=\"${REPO}\", rev=\"${BRANCH}\")); for package in readdir(\"/root/.julia/dev/\"); Pkg.activate(\"/root/.julia/dev/$package\"); Pkg.instantiate(); @eval using $(Symbol(package)); end;"

########################################################
# Clean up
########################################################

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

########################################################
# Download data
########################################################

ENTRYPOINT ${RUN_SCRIPT}