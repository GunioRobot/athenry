TODO
=====

Release 0.2
-----------
* Target resume probably does not work
* Be sure code lives up to guidelines in hacking.markdown
* Direct Users to bugtracker in documentation/wiki
* Direct Users to mailinglist
* Use Jekyll for github pages, move wiki pages there.
* Use .md for markdown
* Create a Roadmap

Release 0.3
-----------
* Global option for passing a chrootdir, all methods should accept this.
* Ability to have more than one stage (custom names)
* Use readline for shell
* Check config for errors and die quickly 

Next
----
* default to pbzip2 if it's installed, else use tar
* build should create a tarball (pull mkstage5 into project)
* Split helper into seperate files so we can include less/more as needed
* Ability to build a chroot based on the current machines world file, parse /var/lib/portage/world
* Ability for users to add bash code to be executed before and after our main scripts
* Ability to detect archive type and use correct tar options
* Ability to build Exherbo stages (2.x)
