TODO
=====

Release 0.3.0
--------------
* build should create a tarball (pull mkstage5 into project)
    - Look into doing this from outside the chroot using ruby
* Use RConfig.add_config_path to provide --config option again.

Next
----
* Shell command needs a way to specify the chrootname you want to work on
* Defined verbosity levels
* Check config for errors and die quickly 
    "fooexample.com" =~ /@(.*)/ and $1 or raise "bad email" 
* default to pbzip2 if installed, else use tar
* Make use of EMERGE\_DEFAULT\_OPTS
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
* Fix known bug:
   1. We update user configs each time we chroot to be sure we have the latest and greatest.
   2. During install_overlays we append a source line to make.conf when using emerge
   3. This gets overwritten the very next time the user runs chroot
      Possible solutions:
      1. Rerun the bash function that adds this line each time we chroot in.
      2. Let users know this happens let them handle it
      3. Don't always copy user configs each time and make sure users know if they update 
         there configs this could happen.
      4. Ideas? Profit??

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
