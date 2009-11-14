if [ ${OVERLAYKEY} ]; then
  
    for (( x=0 ; x < ${#OVERLAYKEY[*]}; x++ )) 
    do
        case ${PKG_MANAGER} in 
        paludis)
            # execute first command
            if [ -z ${OVERLAYVAL[$x]} ]; then
                echo playman -a ${OVERLAYKEY[$x]}
            else
                echo playman --layman-url ${OVERLAYVAL[$x]} -a ${OVERLAYKEY[$x]}
            fi 
            # execute second command
            mkdir -p /var/paludis/repositories/${OVERLAYKEY[$x]}/.cache/names/
            echo paludis -s x-${OVERLAYKEY[$x]}
      ;; 
        emerge)
            # execute first command
            if [ -z ${OVERLAYVAL[$x]} ]; then
                echo layman -a ${OVERLAYKEY[$x]}
            else
                echo layman -f -o ${OVERLAYVAL[$x]} -k -a ${OVERLAYKEY[$x]}
            fi 
            # execute second command
            echo layman -s ${OVERLAYKEY}
        ;; 
    esac
  done
        
fi

#vim:set ft=sh ts=4 sw=4 noet:
