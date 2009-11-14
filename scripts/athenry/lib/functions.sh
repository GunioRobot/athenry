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
        error "Caught CTRL-C exiting soon as it's safe!"
        exit 1
}

function die() {
    msg="${1}"
    error "${msg}"
    exit 1
}

function set_pkgmanager {
    if [ "${NOPALUDIS}" == "true" ]; then
        PKG_MANAGER="emerge"
    fi
    
    case ${PKG_MANAGER} in 
        paludis)
            PKG_NAME="paludis"
            PKG_INSTALL="paludis -i"
            PKG_REMOVE="paludis -u"
            PKG_SYNC="paludis -s"
            PKG_UPDATE="paludis -i everything"
        ;;
        emerge)
            PKG_NAME="emerge"
            PKG_INSTALL="emerge"
            PKG_REMOVE="emerge -C"
            PKG_SYNC="emerge --sync"
            PKG_UPDATE="emerge --keep-going --update --deep system world"
        ;;
        *)
            error "${PKG_MANAGER} is not a valid choice"
            exit 1
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
    if [ ${PKG_NAME} == "paludis" ]; then
        export PALUDIS_CARRY_OUT_UPDATES="yes"
    fi
    ${PKG_SYNC}
}

function bootstrap_pkgmanager {
    case ${PKG_MANAGER} in 
        paludis)
            playman --layman-url http://github.com/gregf/gregf-overlay/raw/master/gregf.xml -a gregf
            rebuild_cache
        ;;
        emerge)
            layman -f -o http://github.com/gregf/gregf-overlay/raw/master/gregf.xml -k -a gregf 
        ;;
        *)
            error "${PKG_MANAGER} is not a valid choice"
            exit 1
        ;;
    esac
}

function bootstrap_overlays {
    if [ ${PKG_NAME} == "paludis" ]; then 
        for overlay in ${OVERLAYS[*]}
        do
            paludis -s x-${overlay}
            mkdir -p /var/paludis/repositories/${overlay}/.cache/names
            chown -R paludisbuild:paludisbuild /var/paludis/repositories/${overlay}
        done
    fi
}

function rebuild_cache {
    paludis --regenerate-installed-cache
    paludis --regenerate-installable-chache
}

function update_configs {
    echo "-5" | etc-update
}

#vim:set ft=sh ts=4 sw=4 noet:
