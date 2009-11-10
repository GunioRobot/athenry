TODO
=====

Release 0.2
-----------
* Split bash into modules
* each bash function should exit upon failure
* use playman/layman for adding overlays. 
* Use method.send and make shellaliases a class
* Dynamicly create alias methods for shellalias using method_instaces(false) and instace_eval
* Be sure code lives up to guidelines in hacking.markdown
* Fix resume tree its wrong right now
* Maybe a depends.rb or something for external libs
* Direct Users to bugtracker in documentation/wiki
* Examples dir for configuration
* Create /usr/share/athenry-$version/{doc,examples}

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
