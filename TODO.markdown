TODO
=====

Release 0.2
-----------
* Freshen class for updating existing stages
* Rake task for install/tests etc
* Split bash into modules
* Check config for errors and die quickly if there is
* each bash function should exit upon failure
* use playman/layman for adding overlays. 
* Paludis should probably make use of update.rb after sync's
* Use method.send and make shellaliases a class
* Dynamicly create alias methods for shellalias using method_instaces(false) and instace_eval
* Rename install.rb -> setup.rb
    setup.rb clean|remove
    setup.rb install
    setup.rb options

Next
----
* default to pbzip2 if it's installed, else use tar
* Use bond to tab complete shell
* Zsh tab completion for athenry bin
* Whitelist filtering for eval
* freshen to update existing stages
* build should create a tarball (pull mkstage5 into project)
* Organize config.yml into sections
* Ability to have more than one stage (prefixed names)
* Look for configs in various locations /etc/athenry $HOME/.config/athenry/ etc..
* Split helper into seperate files so we can include less/more as needed
* Ability to build a chroot based on the current machines world file, parse /var/lib/portage/world
* Ability for users to add bash code to be executed before and after our main scripts
