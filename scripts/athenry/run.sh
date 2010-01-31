#!/bin/bash

set -e

# Set some constants
ATHENRY_ROOT="/root/athenry"
LIB="${ATHENRY_ROOT}/lib"
MODULES="${ATHENRY_ROOT}/modules"
ACTION="${1}"

# @see {file:functions.sh}
source "${LIB}/functions.sh"
setup_chroot
set_pkgmanager

case "${ACTION}" in
    sync)
        source "${MODULES}/sync.sh"
    ;;
    update_pkgmgr)
        source "${MODULES}/update_pkgmgr.sh"
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
    install_sets)
        source "${MODULES}/install_sets.sh"
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
        die "Invalid action!"
esac

#vim:set ft=sh ts=4 sw=4 noet:
