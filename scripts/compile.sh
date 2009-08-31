#!/bin/bash

source /root/config.bash

function error {
    echo -ne " \033[31;01m*\033[0m ${@}\n";
}

function announce {
    echo -ne " \033[32;01m*\033[0m ${@}\n";
}

function set_pkgmanager {
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
            PKG_UPDATE="emerge -D world"
        ;;
        pkgcore)
            PKG_NAME="pmerge"
            PKG_INSTALL="pmerge"
            PKG_REMOVE="pmerge -C"
            PKG_SYNC="pmaint"
            PKG_UPDATE="pmerge -uDs world"
        ;;
        *)
            error "${PKG_MANAGER} is not a valid choice"
            exit 1
        ;;
    esac
}

function bootstrap_pkgmanager {
    if [ ${PKG_NAME} == "paludis" ]; then
        mkdir -p /var/tmp/paludis
        mkdir -p /usr/portage/.cache/names
        mkdir -p /var/paludis/repositories/mpd/.cache/names
        mkdir -p /var/paludis/repositories/gregf/.cache/names
        chown -R paludisbuild:paludisbuild /etc/paludis /usr/portage /var/tmp/paludis /var/paludis
        rebuild_cache
    fi
}

function rebuild_cache {
    paludis --regenerate-installed-cache
    paludis --regenerate-installable-chace
}

function update_pkgmanager { 
    emerge -D world 
    
    case ${PKG_NAME} in
    paludis)
        emerge sys-apps/paludis dev-util/git
        ;;
    pmerge)
        emerge pkgcore
        ;;
    *)
        error "Invalid package manager check your settings and try again!"
        exit 1
        ;;
    esac
}

function sync {
    ${PKG_SYNC}
}


function update_everything {
    ${PKG_UPDATE}
}

function main {
    update_pkgmanager
    bootstrap_pkgmanager
    sync
    rebuild_cache
    update_everything
}


main
