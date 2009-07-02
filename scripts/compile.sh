#!/bin/bash

function paludis {
    emerge dev-util/ccache sys-apps/paludis dev-util/git
}

function sync {
    paludis --sync
}

function mkcache {
    mkdir -p /var/tmp/paludis
    mkdir -p /usr/portage/.cache/names
    mkdir -p /var/paludis/repositories/mpd/.cache/names
    mkdir -p /var/paludis/repositories/gregf/.cache/names
}

function fixperm {
    chown -R paludisbuild:paludisbuild /etc/paludis /usr/portage /var/tmp/paludis /var/paludis
}

function update_cache {
    paludis --regenerate-installed-cache
    paludis --regenerate-installable-chace
}

function update_everything {
    paludis --sync
    paludis -i everything
}

function main {
    paludis
    sync
    mkcache
    fixperm
    update_cache
    update_everything
}


main
