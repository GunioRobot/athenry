TODO
=====

Release 0.2.5
-----------
* Specialized PKG\_INSTALL commands
* Update Docs
* Manpages
* Release
* :force is broking for fetch
* Resume support is broke, rewrite RESUMETREE
* test resume

Release 0.3.0
--------------
* proxy support
    export http_proxy="http://proxy.server.com:port"
    export ftp_proxy="http://proxy.server.com:port"
    [network]
    http_proxy
    ftp_proxy
* sha1 support in Checksum class
* build should create a tarball (pull mkstage5 into project)
    - Look into doing this from outside the chroot using ruby
* Stage 2 support
* Rename arch to be less confusing, think of this more as a configuration profile

Next
----
* Stage 1 support
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
