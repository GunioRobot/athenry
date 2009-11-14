case ${PKG_MANAGER} in
paludis)
    emerge sys-apps/paludis
    ;;
emerge)
    emerge sys-apps/portage app-portage/gentoolkit
    # Do nothing
    ;;
*)
    die "Invalid package manager check your settings and try again!"
    ;;
esac

if [ ${OVERLAYKEY} ]; then
    ${PKG_INSTALL} dev-util/git dev-util/subversion
fi

bootstrap_pkgmanager || die "Failed to boostrap package manager"
#vim:set ft=sh ts=4 sw=4 noet:
