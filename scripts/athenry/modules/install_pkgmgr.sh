emerge --keep-going --update --deep system world

case ${PKG_NAME} in
paludis)
    emerge sys-apps/paludis dev-util/git
    ;;
emerge)
    # Do nothing
    ;;
*)
    error "Invalid package manager check your settings and try again!"
    exit 1
    ;;
esac

bootstrap_pkgmanager
#vim:set ft=sh ts=4 sw=4 noet:
