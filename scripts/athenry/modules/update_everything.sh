if [ ${PKG_MANAGER} == "paludis" ]; then
    export PALUDIS_OPTIONS="--log-level warning --continue-on-failure if-satisfied --dl-reinstall if-use-changed --dl-reinstall-scm weekly"
fi
${PKG_UPDATE} || die "Failed updating everything"

#vim:set ft=sh ts=4 sw=4 noet:
