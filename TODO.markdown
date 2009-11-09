TODO
=====

Release 0.2
-----------
* Freshen class for updating existing stages
* Split bash into modules
* Check config for errors and die quickly 
* each bash function should exit upon failure
* use playman/layman for adding overlays. 
* Use method.send and make shellaliases a class
* Dynamicly create alias methods for shellalias using method_instaces(false) and instace_eval
* Be sure code lives up to guidelines in hacking.markdown
* Fix resume tree its wrong right now
* Mount and Unmount should be preformed automagically.
* Direct Users to bugtracker in documentation/wiki

Next
----
* default to pbzip2 if it's installed, else use tar
* Use readline for shell
* freshen to update existing stages
* build should create a tarball (pull mkstage5 into project)
* Organize config.yml into sections
* Ability to have more than one stage (prefixed names)
* Split helper into seperate files so we can include less/more as needed
* Ability to build a chroot based on the current machines world file, parse /var/lib/portage/world
* Ability for users to add bash code to be executed before and after our main scripts
