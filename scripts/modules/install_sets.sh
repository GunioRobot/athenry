for _set in ${SETS[*]}
do
    case ${PKG_MANAGER} in
    paludis)
        ${PKG_INSTALL} "${_set}" || die "Failed installing set: ${_set}"
        ;;
    portage)
        ${PKG_INSTALL} "@${_set}" || die "Failed installing set: @${_set}"
        ;;
    *)
        die "${PKG_MANAGER} is invalid please see the quickstart guide."
        ;;
    esac
done

#vim:set ft=sh ts=4 sw=4 noet:
