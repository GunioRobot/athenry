trap ctrl_c INT
update_everything
update_configs
fix_broken
if [ ${SETS} ]; then
    install_sets
fi

#vim:set ft=sh ts=4 sw=4 noet:
