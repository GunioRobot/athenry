#!/bin/bash

ATHENRY_ROOT="/root/athenry"
LIB="${ATHENRY_ROOT}/lib"
MODULES="${ATHENRY_ROOT}/modules"
NOPALUDIS="$2"

source "${LIB}/functions.sh"
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
    rebuild)
        source "${MODULES}/rebuild.sh"
    ;;
    rescue)
        bash --rcfile "${MODULES}/rescue.sh"
    ;;
    update_configs)
        source "${MODULES}/update_configs.sh"
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
