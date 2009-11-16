case ${PKG_MANAGER} in
paludis)
    emerge --noreplace --newuse sys-apps/paludis || die "Failed installing paludis"
    bootstrap_pkgmgr || die "Failed to bootstrap package manager!"
    ;;
emerge)
    emerge --noreplace --newuse sys-apps/portage app-portage/gentoolkit || die "Failed installing portage"
    ;;
*)
    die "Invalid package manager check your settings and try again!"
    ;;
esac

if [[ ${OVERLAYKEY} && ${FRESHEN} == "false" ]]; then
    ${PKG_INSTALL} dev-util/git dev-util/subversion || die "Failed installing required git and subversion for overlays"
fi

#vim:set ft=sh ts=4 sw=4 noet:
