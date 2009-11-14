#!/bin/bash

source "${LIB}/config.sh"
source "${LIB}/colors.sh"

function error {
    echo -ne "${yellow}*${normal}${@}\n";
}

function announce {
    echo -ne "${green}*${normal} ${@}\n";
}

function ctrl_c() {
        die "Caught CTRL-C exiting soon as it's safe!"
}

function die() {
    msg="${1}"
    if [ -z ${msg} ]; then
        msg = "Some asshole ran die without setting a message, something broke is all I can tell you. Sorry dude!"
    fi
    error "${msg}"
    exit 1
}

function set_pkgmanager {
    if [ "${NOPALUDIS}" == "true" ]; then
        PKG_MANAGER="emerge"
    fi
    
    case ${PKG_MANAGER} in 
        paludis)
            PKG_INSTALL="paludis -i"
            PKG_REMOVE="paludis -u"
            PKG_SYNC="paludis -s"
            PKG_UPDATE="paludis -i everything"
        ;;
        emerge)
            PKG_INSTALL="emerge"
            PKG_REMOVE="emerge -C"
            PKG_SYNC="emerge --sync"
            PKG_UPDATE="emerge --keep-going --update --deep system world"
        ;;
        *)
            die "${PKG_MANAGER} is not a valid choice"
        ;;
    esac
}

function setup_chroot {
    if [ -e /usr/share/zoneinfo/${TIMEZONE} ]; then 
        cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
    fi
    env-update
    source /etc/profile
    export PS1="(chroot) $PS1"
}

function sync {
    if [ ${PKG_MANAGER} == "paludis" ]; then
        export PALUDIS_CARRY_OUT_UPDATES="yes"
    fi
    ${PKG_SYNC}
}

function rebuild_cache {
    if [ ${PKG_MANAGER} == "paludis" ]; then
        paludis --regenerate-installed-cache
        paludis --regenerate-installable-chache
    fi
}

function update_configs {
    echo "-5" | etc-update
}

#vim:set ft=sh ts=4 sw=4 noet:
