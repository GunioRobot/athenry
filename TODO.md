TODO
=====

Release 0.2.5
-----------
* Specialized PKG\_INSTALL commands
* Update Docs
* Manpages
* Release

Next
----
* Check config for errors and die quickly 
    "fooexample.com" =~ /@(.*)/ and $1 or raise "bad email" 
* default to pbzip2 if installed, else use tar
* Fetch class should have a option to force redownloading.
* Make use of EMERGE\_DEFAULT\_OPTS
* build should create a tarball (pull mkstage5 into project)
* Split helper into separate files so we can include less/more as needed
* Ability to build a chroot based on the current machines world file, parse /var/lib/portage/world
    - Make this a target command possibly clone with the optional path to a world file
* Ability for users to add bash code to be executed before and after our main scripts
* Ability to build Exherbo stages (2.x)
    - Split modules into 3 categories
        - Gentoo
        - Exherbo
        - Shared
    - Split functions and run as needed

Testing
-------
* Create tests/{init.rb, helpers.rb fulltest.rb}
* Rake test
* Big warning about time to run
* Create config.rb.tests in tests dir
* Run setup, wipe clean
* Run target stage3, clean chrootdir
* Run freshen
* Run target custom, clean chrootdir
    - Run freshen
    - Run each twice once for emerge and once for paludis
