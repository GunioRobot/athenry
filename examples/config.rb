CONFIG.workdir = "/var/tmp/athenry/"
CONFIG.stageurl = "http://mirrors.kernel.org/gentoo/releases/amd64/autobuilds/current-stage3/stage3-amd64-20091112.tar.bz2"
CONFIG.snapshoturl = "http://mirrors.kernel.org/gentoo/snapshots/portage-latest.tar.bz2"
CONFIG.arch = "amd64"
CONFIG.verbose = "true"
CONFIG.pkgmanager = "paludis"
CONFIG.sets = %w[stage4]
CONFIG.timezone = "EST5EDT"
CONFIG.overlays = {
    :mpd => "http://github.com/gregf/mpd/raw/master/mpd.xml",
    :sunrise => nil,
    }
