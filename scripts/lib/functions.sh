#!/bin/bash

source "${LIB}/config.sh"
source "${LIB}/colors.sh"

# Displays a error message to the user
# @param [String] msg Error message to be displayed
# @example error "Something Failed!" #=> "Something Failed!"
function error {
    echo -ne "${boldred}*${normal} ${@}\n";
}

# Displays a warning message to the user
# @param [String]
# @example warning "This should be this" #=> "This should be this"
function warning {
    echo -ne "${yellow}*${normal} ${@}\n";
}

# Display an announcement message to the user
# @param [String]
# @example "Something happened correctly" #=> "Something happened correctly"
function announce {
    echo -ne "${green}*${normal} ${@}\n";
}

# Used for trap statements
function ctrl_c() {
        die "Caught CTRL-C exiting soon as it's safe!"
}

# Display a error message using the error method, then exit 1
# If there is no error msg provided mock the developer a bit.
# @param die [String] msg Message to display before we exit 1
# @example die "Something died, programmers are idiots!" #=> 1
function die() {
    msg="${1}"
    if [ -z "${msg}" ]; then
        msg = "Some asshole ran die without setting a message, something broke is all I can tell you. Sorry dude!"
    fi
    error "${msg}"
    exit 1
}

# Sets the package manager based on some constants
# If NOPALUDIS is set it will default to emerge for the duration.
# If FRESHEN is set it will check to be sure paludis is installed,
# if not fall back to emerge
# @param [String] PKG_MANAGER The package manager we are using
# @param [Optional, [true,false]] FRESHEN Weather or not we should verify paludis is actually installed.
# @param NOPALUDIS [Optional, [true,false]] NOPALUDIS Never use paludis
function set_pkgmanager {
    if [ "${NOPALUDIS}" == "true" ]; then
        PKG_MANAGER="emerge"
    fi

    if [[ "${FRESHEN}" == "true" && "${PKG_MANAGER}" == "paludis" ]]; then
        if [[ ! -x /usr/bin/paludis ]]; then
            PKG_MANAGER="emerge"
        fi
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
        PKG_UPDATE="emerge --newuse --keep-going --update --deep system world"
    ;;
    *)
        die "${PKG_MANAGER} is invalid please see the quickstart guide."
    ;;
    esac
}

# Sets up the environment for the chroot
# @param [String] TIMEZONE The timezone to use for our chroot
# @see ls /usr/share/zoneinfo/ to choose
function setup_chroot {
    if [ -e /usr/share/zoneinfo/"${TIMEZONE}" ]; then
        cp /usr/share/zoneinfo/"${TIMEZONE}" /etc/localtime
    fi
    eselect profile set "${PROFILE}"
    env-update
    source /etc/profile
    export PS1="(chroot) $PS1"
}

# Syncs the portage tree
# @param PKG_MANAGER [Optional, String] PKG_MANAGER Package manager we are using
# @param [String] SYNC Sync options for our PKG_MANAGER
function sync {
    if [ ${PKG_MANAGER} == "paludis" ]; then
        export PALUDIS_CARRY_OUT_UPDATES="yes"
    fi
    ${PKG_SYNC}
}

# If we are using paludis rebuild the cache
# @param [Optional, String] PKG_MANAGER Package manager we are using
function rebuild_cache {
    REPO="${1}"
    if [ ${PKG_MANAGER} == "paludis" ]; then
        if [ -n "${REPO}" ]; then
            paludis --regenerate-installed-cache "${REPO}" || die "failed installing cache for ${REPO}"
            paludis --regenerate-installable-cache "${REPO}" || die "failed installing installable cache for ${REPO}"
        else
            paludis --regenerate-installed-cache || die "failed installing cache"
            paludis --regenerate-installable-cache  || die "failed installing installable cache"
        fi
    fi
}

function add_to_make_conf {
    if [ ${PKG_MANAGER} == "emerge" ]; then
        if [ -f /var/lib/layman/make.conf ]; then
            echo 'source "/var/lib/layman/make.conf"' >> /etc/make.conf
        elif [ -f /usr/portage/local/layman/make.conf ]; then
            echo 'source "/usr/portage/local/layman/make.conf"' >> /etc/make.conf
        elif [ -f /usr/local/portage/layman/make.conf ]; then
            echo 'source "/usr/local/portage/layman/make.conf"' >> /etc/make.conf
        else
            die "Failed adding layman source to make.conf"
        fi
    fi
}

# Creates temporary directories and and fixes permissions.
# @param [Optional, String] PKG_MANAGER Package manager we are using
function bootstrap_pkgmgr {
    if [ ${PKG_MANAGER} == "paludis" ]; then
        mkdir -p /var/tmp/paludis
        mkdir -p /var/cache/paludis
        mkdir -p /var/paludis
        mkdir -p /var/log/paludis
        mkdir -p /usr/portage/.cache/names
        chown -R paludisbuild:paludisbuild /etc/paludis /usr/portage /var/tmp/paludis /var/paludis /var/cache/paludis /var/log/paludis
        find /usr/portage -type d -exec chmod g+wrx {} \;
        find /var/tmp/paludis -type d -exec chmod g+wrx {} \;
        rebuild_cache
    fi
}

#vim:set ft=sh ts=4 sw=4 noet:
