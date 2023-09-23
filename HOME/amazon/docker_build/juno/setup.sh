#! /usr/bin/env bash

set -ex

# To be run inside docker only

if [ ! -f /.dockerenv ]; then
    docker run -it -v ~/juno:/home/$(whoami)/juno \
               -v ~/.ssh:/home/$(whoami)/.ssh:ro \
               -v ~/.gitconfig:/home/$(whoami)/.gitconfig:ro \
               amazon-ubuntu-juno-2 /home/$(whoami)/juno/setup.sh
    
    exit 0
fi

BRANCH_NAME="mainline"
DATE=$(date +"%Y%m%d_%H%M%S")

REPO_NAME="${BRANCH_NAME}_${DATE}"

mkdir /home/$(whoami)/juno/${REPO_NAME}
cd /home/$(whoami)/juno/${REPO_NAME}

~/bin/repo init -u ssh://gerrit.ereader.amazon.dev:9418/eink/src/manifest -b eink/dev/${BRANCH_NAME} -m default.xml
~/bin/repo sync -c -j50
~/bin/repo start --all ${BRANCH_NAME}

git apply /home/$(whoami)/juno/patch1.patch --directory=meta-eink

source meta-eink/env/eink-bellatrix-setup
bitbake bootup-image-bellatrix
sh ../meta-eink/images/full-image.sh
