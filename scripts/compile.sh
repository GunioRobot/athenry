#!/bin/bash

source /root/config.bash

function error {
    echo -ne " \033[31;01m*\033[0m ${@}\n";
}

function announce {
    echo -ne " \033[32;01m*\033[0m ${@}\n";
}

function ctrl_c() {
        error "Caught CTRL-C exiting soon as it's safe!"
        exit 2
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

function setup_chroot {
    if [ -e /usr/share/zoneinfo/${TIMEZONE} ]; then 
        cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
    fi
    env-update
    source /etc/profile
    export PS1="(chroot) $PS1"
}

function bootstrap_pkgmanager {
    if [ ${PKG_NAME} == "paludis" ]; then
        mkdir -p /var/tmp/paludis
        mkdir -p /usr/portage/.cache/names
        chown -R paludisbuild:paludisbuild /etc/paludis /usr/portage /var/tmp/paludis /var/paludis
        rebuild_cache
    fi
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

function install_sets {
    for _set in ${SETS[*]}
    do
        ${PKG_INSTALL} "${_set}"
    done
}

function rebuild_cache {
    paludis --regenerate-installed-cache
    paludis --regenerate-installable-chache
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
    emerge)
        # Do nothing
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
    if [ ${PKG_NAME} == "paludis" ]; then
        export PALUDIS_OPTIONS="--log-level warning --continue-on-failure if-satisfied --dl-reinstall if-use-changed --dl-reinstall-scm weekly"
    fi
    ${PKG_UPDATE}
}

function fix_broken {
    case ${PKG_NAME} in
        paludis)
            export RECONCILIO_OPTIONS="--continue-on-failure if-satisfied"
            reconcilio
            python-updater -P paludis
        ;;
        pmerge)
            python-updater -P pkgcore
            # No idea how pkgcore works yet...
        ;;
        emerge)
            revdep-rebuild -P
            python-updater -P portage
        ;;
        *)
        error "Invalid package manager check your settings and try again!"
        exit 1
        ;;
    esac
}

function freshen {
    trap ctrl_c INT
    setup_chroot
    set_pkgmanager
    bootstrap_pkgmanager
    sync
    update_everything
    fix_broken
}

function main {
    trap ctrl_c INT
    setup_chroot
    set_pkgmanager
    update_pkgmanager
    bootstrap_pkgmanager
    sync
    if [ ${OVERLAYS} ]; then
        bootstrap_overlays
    fi
    if [ ${PKG_NAME} == "paludis"]; then
        rebuild_cache
    fi
    update_everything
    fix_broken
    if [ ${SETS} ]; then
        install_sets
    fi
}


main
