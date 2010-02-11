if [ -f /usr/portage/scripts/bootstrap.sh ]; then
    cd /usr/portage
    announce "Fetching files..."
    scripts/bootstrap.sh -f
    announce "Boot Strapping System"
    scripts/bootstrap.sh
else
    die "Unable to run /usr/portage/scripts/bootstrap.sh"
fi
#vim:set ft=sh ts=4 sw=4 noet:
