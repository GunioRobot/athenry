case ${PKG_NAME} in
paludis)
    emerge sys-apps/paludis dev-util/git
    ;;
emerge)
    # Do nothing
    ;;
*)
    die "Invalid package manager check your settings and try again!"
    ;;
esac

bootstrap_pkgmanager
#vim:set ft=sh ts=4 sw=4 noet:
