#!/bin/bash

ATHENRY_ROOT="/root/athenry"
LIB="${ATHENRY_ROOT}/lib"
MODULES="${ATHENRY_ROOT}/modules"

source "${LIB}/functions.sh"

setup_chroot
set_pkgmanager

case $1 in
    sync)
        source "${MODULES}/sync.sh"
    ;;
    update_pkgmgr)
        source "${MODULES}/update_pkgmgr.sh"
    ;;
    repair)
        source "${MODULES}/repair.sh"
    ;;
    freshen)
        source "${MODULES}/freshen.sh"
    ;;
    chroot)
        source "${MODULES}/chroot.sh"
    ;;
    update_everything)
        source "${MODULES}/update_everything.sh"
    ;;
    tar)
        source "${MODULES}/tar.sh"
    ;;
    install_overlays)
        source "${MODULES}/install_overlays.sh"
    ;;
    install_pkgmgr)
        source "${MODULES}/install_pkgmgr.sh"
    ;;
    *)
        error "Invalid action!"
        exit 1
esac

#vim:set ft=sh ts=4 sw=4 noet:
