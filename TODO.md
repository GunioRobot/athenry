TODO
=====

Release 0.2
-----------
* Documentation should mention sets support for emerge
    - Required >=2.2 which is masked
    - Link to documentation on setting up sets with portage
    - Explain they will need to unmask for sets to be installed
* Release

Release 0.3
-----------
* Global option for passing a chrootdir, all methods should accept this.
* Ability to have more than one stage (custom names)
    - This means name.log for log files
    - name.state for state files
* Use readline for shell
* Check config for errors and die quickly 
* Specialized PKG\_INSTALL commands
* Make sync friendly to the gentoo mirrors cache a updated copy locally to be used.
* Rake task to install gems
* New workdir structure
    - workdir
    - workdir/chroot\_name
    - workdir/portage/{portage-latest, cache}
    - workdir/stages/{stage3.tar.bz2, built}
    - workdir/var/{log, state}

Next
----
* default to pbzip2 if installed, else use tar
* Make use of EMERGE\_DEFAULT\_OPTS
* build should create a tarball (pull mkstage5 into project)
* Split helper into separate files so we can include less/more as needed
* Ability to build a chroot based on the current machines world file, parse /var/lib/portage/world
    - Make this a target command possibly clone with the optional path to a world file
* Ability for users to add bash code to be executed before and after our main scripts
* Ability to detect archive type and use correct tar options
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
