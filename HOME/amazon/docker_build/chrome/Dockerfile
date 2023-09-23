FROM ubuntu:22.04

# Name of the user account to ease authentication.
# We should set the value for this arg during build and must be same as
# our amazon login username.
ARG username
ARG uid
ARG gid

# Enable 32 bit libraries and Install essential libraries
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
        git vim gawk wget diffstat unzip texinfo gcc build-essential \
        chrpath socat cpio python3 python3-pip python3-pexpect xz-utils \
        debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa \
        libsdl1.2-dev pylint xterm python3-subunit mesa-common-dev zstd \
        liblz4-tool lsb-core sudo apt-transport-https lsb-release ninja-build \
        default-jdk python2 gperf binutils-arm-linux-gnueabihf bison \
        gcc-multilib libgtk2.0-0:i386 libnss3:i386 libxtst6:i386

# Create a new user with name `username` with a default password and add to
# `sudo` group.
# We should create user before running amazonify script to avoid password rules.
RUN useradd -ms /bin/bash ${username} \
    && echo "${username}:amazon" | chpasswd \
    && usermod -aG sudo -u ${uid} -g ${gid} ${username}

# link/set python2 as default python
RUN ln -s /usr/bin/python2 /usr/bin/python

# Copy and run the amazonify script
COPY ./amazonify-ubuntu /tmp
RUN bash /tmp/amazonify-ubuntu -t core

# Set the current user and workdir
USER ${username}
WORKDIR /home/${username}

# Generate keygen for mwinit to sign
RUN ssh-keygen -t ecdsa -b 521 -N '' -f ~/.ssh/id_ecdsa

