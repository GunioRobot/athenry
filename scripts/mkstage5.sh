#!/bin/bash -x

WORK="/home/gregf/staging"
BASE="${WORK}/stage5"
CONFIGS="/home/gregf/mkstage5/etc/amd64"
SCRIPTS="/home/gregf/mkstage5/scripts"
URL="http://mirrors.kernel.org/gentoo/releases/amd64/current/stage3-amd64-20090625.tar.bz2"
SNAPSHOT="http://gentoo.osuosl.org/snapshots/portage-latest.tar.bz2"

mkdir -p ${BASE} 
cd ${WORK}

function fetch() {
    wget -c ${URL} -O ${WORK}/stage3-amd64-current.tar.bz2
}

function extract() {
    sudo tar xvjpf stage3-amd64-current.tar.bz2 -C ${BASE}
}

function mount() {
    sudo mount -o bind /dev ${BASE}/dev
    sudo mount -o bind /sys ${BASE}/sys
    sudo mount -t proc none ${BASE}/proc
}

function copy_configs {
    sudo cp ${CONFIGS}/resolv.conf ${BASE}/etc/resolv.conf
    sudo cp ${CONFIGS}/make.conf ${BASE}/etc/make.conf
    sudo cp -R ${CONFIGS}/paludis/ ${BASE}/etc/
    sudo cp -R ${CONFIGS}/portage/ ${BASE}/etc/
}

function copy_scripts {
    sudo cp ${SCRIPTS}/compile.sh ${BASE}/root/compile.sh
}

function snapshot {
    wget -c ${SNAPSHOT} -O ${WORK}/portage-latest.tar.bz2
    sudo tar xvjpf ${WORK}/portage-latest.tar.bz2 -C ${BASE}/usr
}

function chroot {
    sudo chmod +x ${BASE}/root/compile.sh
    sudo chroot ${BASE} /root/compile.sh
}
function main() {
    #fetch
    #extract
    #mount
    #snapshot
    copy_configs
    copy_scripts
    chroot
}

main
