case ${PKG_MANAGER} in
    paludis)
        export RECONCILIO_OPTIONS="--continue-on-failure if-satisfied"
        reconcilio
        python-updater -P paludis
    ;;
    emerge)
        revdep-rebuild -P
        python-updater -P portage
    ;;
    *)
    die "Invalid package manager check your settings and try again!"
    ;;
esac
