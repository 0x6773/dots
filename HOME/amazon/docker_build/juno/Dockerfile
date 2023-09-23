FROM ubuntu:16.04

# Name of the user account to ease authentication.
# We should set the value for this arg during build and must be same as
# our amazon login username.
ARG username
ARG uid
ARG gid

# Enable 32 bit libraries and Install essential libraries
RUN apt update \
    && apt upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
    gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential zlib1g-dev libncurses5-dev libgdbm-dev \
    libnss3-dev libssl-dev libreadline-dev libffi-dev chrpath \
    socat libsdl1.2-dev xterm lib32ncurses5 lib32z1 \
    ant gcc-multilib g++-multilib munge libglib2.0-dev libpulse-dev \
    zip docbook curl vim cpio gtk+3.0 python3 htop sudo -y

RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# Create a new user with name `username` with a default password and add to
# `sudo` group.
# We should create user before running amazonify script to avoid password rules.
RUN useradd -ms /bin/bash ${username} \
    && echo "${username}:amazon" | chpasswd \
    && usermod -aG sudo -u ${uid} -g ${gid} ${username}

WORKDIR /tmp

# install ssh 7.4 version
RUN wget https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.4p1.tar.gz \
    && tar xfz openssh-7.4p1.tar.gz \
    && cd openssh-7.4p1 \
    && ./configure \
    && make -j16 \
    && make install \
    && cd .. \
    && rm -r openssh-7.4p1 openssh-7.4p1.tar.gz

USER ${username}

RUN mkdir -p /home/${username}/bin \
    && curl https://storage.googleapis.com/git-repo-downloads/repo-1 > /home/${username}/bin/repo \
    && chmod a+x /home/${username}/bin/repo \
    && touch /home/${username}/.sudo_as_admin_successful

WORKDIR /home/${username}
