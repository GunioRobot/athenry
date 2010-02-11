#!/bin/bash

set -e

# Set some constants
ATHENRY_ROOT="/scripts"
LIB="${ATHENRY_ROOT}/lib"
MODULES="${ATHENRY_ROOT}/modules"
ACTION="${1}"

# @see {file:functions.sh}
source "${LIB}/functions.sh"
setup_chroot
set_pkgmanager

case "${ACTION}" in
    sync)
        run_module sync
    ;;
    update_pkgmgr)
        run_module update_pkgmgr
    ;;
    rebuild)
        run_module rebuild
    ;;
    rescue)
        bash --rcfile "${MODULES}/rescue.sh"
    ;;
    update_configs)
        run_module update_configs
    ;;
    install_sets)
        run_module install_sets
    ;;
    update_everything)
        run_module update_everything
    ;;
    install_overlays)
        run_module install_overlays
    ;;
    install_pkgmgr)
        run_module install_pkgmgr
    ;;
    emerge_system)
        run_module emerge_system
    ;;
    bootstrap)
        run_module bootstrap
    ;;
    *)
        die "Invalid action!"
esac

#vim:set ft=sh ts=4 sw=4 noet:
