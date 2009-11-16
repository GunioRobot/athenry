if [ ${OVERLAYKEY} ]; then
  
    for (( x=0 ; x < ${#OVERLAYKEY[*]}; x++ )) 
    do
        case ${PKG_MANAGER} in 
        paludis)
            # execute first command
            if [ -z ${OVERLAYVAL[$x]} ]; then
                playman -a ${OVERLAYKEY[$x]} || die "Failed adding overlay ${OVERLAYKEY[$x]}"
            else
                playman --layman-url ${OVERLAYVAL[$x]} -a ${OVERLAYKEY[$x]} || die "Failed adding overlay ${OVERLAYKEY[$x]} with provided data ${OVERLAYVAL[$x]}"
            fi 
            # execute second command
            paludis -s x-${OVERLAYKEY[$x]} || die "Failed syncing x-${OVERLAYKEY[$x]}"
            mkdir -p /var/paludis/repositories/${OVERLAYKEY[$x]}/.cache/names/
      ;; 
        emerge)
            # execute first command
            if [ -z ${OVERLAYVAL[$x]} ]; then
                layman -a ${OVERLAYKEY[$x]} || die "Failed adding overlay ${OVERLAYKEY[$x]}"
            else
                layman -f -o ${OVERLAYVAL[$x]} -k -a ${OVERLAYKEY[$x]} || die "Failed adding overlay ${OVERLAYKEY[$x]} with provided data ${OVERLAYVAL[$x]}"
            fi 
            # execute second command
            layman -s ${OVERLAYKEY} || die "Failed to sync ${OVERLAYKEY} overlay"
        ;; 
    esac
  done
        
fi

rebuild_cache || die "Failed to rebuild paluids cache after adding overlays"

#vim:set ft=sh ts=4 sw=4 noet:
