TODO
=====

Release 0.2
-----------
* Split bash into modules
* each bash function should exit upon failure
* use playman/layman for adding overlays. 
* Be sure code lives up to guidelines in hacking.markdown
* Fix resume tree its wrong right now
* Direct Users to bugtracker in documentation/wiki

Next
----
* Freshen class for updating existing stages
* Check config for errors and die quickly 
* default to pbzip2 if it's installed, else use tar
* Use readline for shell
* freshen to update existing stages
* build should create a tarball (pull mkstage5 into project)
* Organize config.yml into sections
* Ability to have more than one stage (prefixed names)
* Split helper into seperate files so we can include less/more as needed
* Ability to build a chroot based on the current machines world file, parse /var/lib/portage/world
* Ability for users to add bash code to be executed before and after our main scripts
