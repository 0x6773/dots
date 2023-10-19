#! /usr/bin/env zsh

# old file, dont source this

local _SLATE_LOCAL_DIR="/Users/gosahai/workplace/slate_cd"
local _SLATE_CD_DIR="/home/gosahai/slate"

function chr_build() {
    local NINJA_OUT_DIR=${1}
    echo -e "${green}[+] Build | kindle_browser | ${NINJA_OUT_DIR}"
    ssh cd "docker exec -w ~/slate/src slate ~/slate/depot_tools/autoninja -C ${NINJA_OUT_DIR} kindle_browser"
}

function chr_strip() {
    local NINJA_OUT_DIR=${1}
    echo -e "${lcyan}[+] Strip | kindle_browser | ${NINJA_OUT_DIR}"
    ssh cd "cd ~/slate/src && \
            mkdir -p ${NINJA_OUT_DIR}/stripped && \
            ./native_client/toolchain/linux_x86/nacl_arm_glibc/arm-nacl/bin/strip -o ${NINJA_OUT_DIR}/stripped/kindle_browser ${NINJA_OUT_DIR}/kindle_browser && \
            du -sh ${NINJA_OUT_DIR}/stripped/kindle_browser"
}

function chr_pull() {
    local NINJA_OUT_DIR=${1}
    echo -e "${green}[+] Pull | kindle_browser | ${NINJA_OUT_DIR}"
    rsync -chavzP --stats cd:${_SLATE_CD_DIR}/src/${NINJA_OUT_DIR}/stripped/kindle_browser ${_SLATE_LOCAL_DIR}/kindle_browser
}

function chr_squash() {
    echo -e "${lcyan}[+] Squash | kindle_browser"
    local KB_SQUASH_PATH="${_SLATE_LOCAL_DIR}/chromium_squashfs/bin/kindle_browser"
    rm -r ${_SLATE_LOCAL_DIR}/chromium.sqsh ${KB_SQUASH_PATH}
    cp ${_SLATE_LOCAL_DIR}/kindle_browser ${KB_SQUASH_PATH}
    patchelf --set-interpreter /usr/bin/chromium/lib/ld-linux-armhf.so.3 ${KB_SQUASH_PATH}
    mksquashfs ${_SLATE_LOCAL_DIR}/chromium_squashfs ${_SLATE_LOCAL_DIR}/chromium.sqsh
}

function chr_pushsquash() {
    echo -e "${green}[+] Push Squash | kindle_browser"
    adb push ${_SLATE_LOCAL_DIR}/chromium.sqsh /mnt/us
}

function chr_mountsquash() {
    echo -e "${lcyan}[+] Mount Squash | kindle_browser"
    adb shell umount /chroot/usr/bin/chromium
    local FREE_LOOP_DEVICE="$(adb shell losetup -f | ggrep -Po \\d+)"
    adb shell mount -o loop=/dev/loop/${FREE_LOOP_DEVICE} -t squashfs /mnt/us/chromium.sqsh /chroot/usr/bin/chromium
}

function chr_deploy() {
    NINJA_OUT_DIR=${1}
    chr_build ${NINJA_OUT_DIR}
    chr_strip ${NINJA_OUT_DIR}
    chr_pull ${NINJA_OUT_DIR}
    chr_squash
    chr_pushsquash
    chr_mountsquash
}

function chr_getsquashfs() {
    rm -r ${_SLATE_LOCAL_DIR}/chromium.original.sqsh ${_SLATE_LOCAL_DIR}/chromium_squashfs
    adb pull /usr/bin/chromium.sqsh ${_SLATE_LOCAL_DIR}/chromium.original.sqsh
    unsquashfs -d ${_SLATE_LOCAL_DIR}/chromium_squashfs ${_SLATE_LOCAL_DIR}/chromium.original.sqsh
}

function __chr_fix() {
    adb shell mount -o remount,rw /
    local RESULT=$(adb shell "[ -f /usr/bin/mesquite_bak ] || echo 1")
    if [ -n "${RESULT}" ]; then
        adb shell cp /usr/bin/mesquite /usr/bin/mesquite_bak
        local TEMP_FIX=$(mktemp)
        cat <<< '#! /bin/bash
        /usr/bin/browser -j' > ${TEMP_FIX}
        chmod +x ${TEMP_FIX}
        adb push ${TEMP_FIX} /usr/bin/mesquite_chr
        adb shell cp /usr/bin/mesquite_chr /usr/bin/mesquite
    fi
}

function kpp_build() {
	cd /Volumes/workplace/workplace/KPPAll/src/KPPBrowser
	brazil-build --platform eink 
	cd /Volumes/workplace/workplace/KPPAll/src/KPPMainApp
	brazil-build --platform eink
	TEMP_DIR=$(mktemp -d)
	strip -o ${TEMP_DIR}/KPPMainApp /Volumes/workplace/workplace/KPPAll/src/KPPMainApp/build/bin/eink/KPPMainAppV2
	adb push ${TEMP_DIR}/KPPMainApp /mnt/us/KPPMainApp
	adb shell rm /app/bin/KPPMainApp
	adb shell ln -s /mnt/us/KPPMainApp /app/bin/KPPMainApp
	adb shell stop kppmainapp
	adb shell start kppmainapp
}

function kpp_ui_build() {
	brazil-recursive-cmd 'brazil-build'
	adb push build/eink-artifactory/app/KPPMainApp/* /app/KPPMainApp
	# adb shell stop kppmainapp
	# adb shell start kppmainapp
}


