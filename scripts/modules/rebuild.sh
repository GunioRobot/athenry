case ${PKG_MANAGER} in
    paludis)
        export RECONCILIO_OPTIONS="--continue-on-failure if-satisfied"
        reconcilio || die "reconcilio failed!"
        python-updater -P paludis || die "python updater failed!"
    ;;
    portage)
        emerge @preserved-rebuild
        revdep-rebuild || die "revdep-rebuild failed!"
        python-updater -P portage || die "python updater failed!"
    ;;
    *)
    die "Invalid package manager check your settings and try again!"
    ;;
esac
