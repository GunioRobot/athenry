for _set in ${SETS[*]}
do
    ${PKG_INSTALL} "${_set}" || die "Failed installing set: ${_set}"
done

#vim:set ft=sh ts=4 sw=4 noet: