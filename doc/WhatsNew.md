Whats New?
==========

v0.2.5
------
###Core
    * \[core\] Setup command now takes commands only
    * \[core\] Target command has a setup target, this is the old setup command
    * \[core\] Shell is now using ruby readline. Tab completion and history management have been added.
    * \[core\] Sync class for working with rsync
    * \[core\] Checksum class for checking md5sums
    * \[core\] Fetch class, we no longer depend on wget
    * \[core\] Extract class, for handling tar and bz2 extraction
    * \[core\] Scripts are now copied to chroot/scripts rather than /root/scripts
    * \[core\] Switched from configatron to RConfig, old configuration files are now invalid
    * \[core\] New dependency on ruby-progressbar
    * \[core\] Switched from erb to erubis

#Manpages
    * \[manpages\] Added Manpages

#Installer
    * \[installer\] Installer now installs athenry to the ruby sitelibdir

###Bugfixes
    * \[bugfix\] Layman was not correctly installing overlays when using emerge
    * \[bugfix\] No longer run sync everytime, using a snapshot cache that respect Gentoo Netiquette
    * \[bugfix\] etc\_update was not run in multiple places do to a typo


v0.2
----

###Core
* \[core\] Freshen command
* \[core\] Rescue command
* \[core\] target command

###Bugfixes
* \[bugfix\] Loads of bug fixes

###Scripts
* \[Scripts\] Rewrote code to be modular


v0.1.1
------
* \[bugfix\] Actually recursively copy all configs.

v0.1a
-----
* Initial alpha release for testing, can build stage4's from a stage3. Basic resume support. 
