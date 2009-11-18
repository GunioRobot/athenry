---
layout: default
title: Quickstart Guide 
---

Quickstart Index 
----------------

* [Where to download?](#where_to_download)
* [Installation](#installation)
* [Configuration](#configuration)
* [Usage](#usage)
* [Commands](#commands)  
    * [setup](#setup)  
    * [build](#build)  
    * [target](#target)  
    * [rescue](#rescue)  
    * [resume](#resume)  
    * [freshen](#freshen)  
    * [clean](#clean)  
    * [shell](#shell)  
* [Notes](#notes)

Where to download?
------------------

The best way to get Athenry is to check out the latest release branch from
github.

    $ git clone git://github.com/gregf/athenry.git athenry

Installation
------------

After checking out a fresh copy of Athenry from git or extracting a previously
downloaded tarball, Athenry needs to be installed. To install Athenry run
install.rb.

    $ cd athenry
    $ ./install.rb

Configuration
-------------

Athenry stores all configuration data in a plain text yaml file. During
Athenry's first installation, config.rb.example is copied to
/etc/athenry/config.rb.example. Athenry will not run until this file is
reviewed and then renamed to config.rb. The default configuration options
provided in /etc/athenry/config.rb.example are sane defaults that the developers
chose. These settings should work for most anyone that would like to give
Athenry a try.

With that said, it is a good idea to review the config file to see if there are
configuration options that may work better for you such as the working directory,
your timezone, and even what mirrors to use. As the config.rb in etc are settings
the developers consider sane defaults, it is highly recommend that config.rb
be copied to $HOME/.config/athenry/config.rb. Athenry actually checks for
$HOME/.config/athenry/config.rb for it's configuration settings before looking
in /etc/athenry/config.rb. All changes to Athenry's configuration and settings
should be made to this local configuration file. That way /etc/athenry/config.rb
will always be there for reference in case you make a change and Athenry no
longer does what is expected. Another detail to keep in mind is every time
Athenry is updated, /etc/athenry/config.rb is overwritten with any new
configuration options, deprecated options are removed, any changes that the devs
may think are better defaults now will be updated. To put it simply, any personal
changes made to the config in etc will be overwritten with Athenry's updated config.

The developers recommend that you update Athenry regularly, then diff the local
Athenry config file in $HOME to the Athenry config in etc. Think of this as a
"manual" etc-update. This is an easy way to see what new features Athenry has,
any changes in how Athenry works, and any options or functions that have been
deprecated and/or removed

The following is the list of Athenry's currently sane defaults and available
settings.

###config.rb:

    CONFIG.workdir = "/var/tmp/athenry/"
    CONFIG.stageurl = "http://mirrors.kernel.org/gentoo/releases/amd64/autobuilds/current-stage3/stage3-amd64-20091112.tar.bz2"
    CONFIG.snapshoturl = "http://mirrors.kernel.org/gentoo/snapshots/portage-latest.tar.bz2"
    CONFIG.arch = "amd64"
    CONFIG.verbose = "true"
    CONFIG.pkgmanager = "paludis"
    CONFIG.sets = %w[stage4 games]
    CONFIG.timezone = "EST5EDT"
    CONFIG.overlays = {
        :mpd => "http://github.com/gregf/mpd/raw/master/mpd.xml",
        :sunrise => nil,
        }

**workdir**
: This is the root directory where created stages, logs, the state file, and downloaded files will be stored.

**stageurl**
: This is the url where Athenry will grab the stage seed from.

**snapshoturl**
: This is the url where Athenry will grab the portage snapshot from.

**arch**
: This is the architecture you plan on building for.

**verbose**
: Does just what it implies, toggles verbosity. Even with this set to
false you can tail the log file to see the progress.

**overlays**
: This takes a hash of overlays you would like to use. You can optionally
specify an additional overlay url to be pulled in. This data is then passed onto either 
layman or playman.

**pkgmanager**
: This can be set to either paludis or emerge. 

**sets**
: An array listing set files to install. This is how packages to be
installed into the chroot is handled.

**timezone**
: Timezone to be set for the chroot. 

Usage
-----

  NAME:

    Athenry

  DESCRIPTION:

    Creates a Gentoo chroot and automates stage building

  COMMANDS:

    build                Executes a single command on the giving chroot [command]
    clean                Cleans up our mess [options]
    freshen              Updates an existing chroot
    help                 Display global or [command] help documentation.
    rescue               Chroot into your stage to perform commands manually
    resume               Resume from last state
    setup                Fetches files and creates necessary directories
    shell                Run athenry commands directly through irb like shell
    target               Starts building a target stage

  GLOBAL OPTIONS:

    -c, --config FILE
        Load config data for your commands to use

    -h, --help
        Display help documentation

    -v, --version
        Display version information

    -t, --trace
        Display backtrace when an error occurs

  AUTHOR:

    Greg Fitzgerald <netzdamon@gmail.com>


Commands
--------

###setup:
________

The setup command does a number of things for you. It fetches your stage file
and a portage snapshot. It checks the md5sums those files. It also creates the
necessary directory structure for Athenry to properly operate.

    $ athenry setup

###build:
_________

The build command is used for issuing single commands to the build process. For example:

    $ athenry build install_pkgmgr

All commands run from build are performed inside the chroot. Here is a list of commands you can run.

**sync**
: Syncs the portage tree.

**install\_pkgmgr**
: Installs the package manager you have set.

**update\_everything**
: Updates all packages in your chroot.

**etc\_update**
: Updates out of date configuration files in your chroot.

**install\_overlays**
: Installs overlays you have specified in config.rb

**install\_sets**
: Installs the sets you have specified in config.rb

**rebuild**
: Rebuilds packages with broken linkage, also runs python-updater.

###target:

The target command is used to build an entire stage file in one swoop. It runs setup if it has not already been run. It will then go through all the necessary build steps in the correct order to build your stage.

    $ athenry target stage3

**stage3**
: Builds a stage3 

**custom**
: Builds a custom stage using sets and overlays.

Currently stage3 and custom are the only stages supported. If you plan to
install sets you will want to use the custom target.

###rescue:
__________

Rescue is for when something goes wrong, and it will. Athenry tries to build
your stage in a way that won't cause you headaches. That being said there is
always problems that can a cure. Since we do not support building for a stage1
yet, nor will we require you to, we offer the rescue command. This simply
chroots into your working chroot and allows you to fix any blockages or other
issues that may have happened. You can thing resume from where you left off.

    $ athenry rescue 

###resume:
__________

This should pick up where Athenry left off. Currently there is a small
limitation on resume support. If Athenry is stopped at the last step of setup
Athenry will not know to start running build. This will be resolved in a future
release.

    $ athenry resume

###freshen:
___________

Freshen will take your existing chroots and update them.

    $ athenry freshen <chroot>

###clean:
_________

Currently only performs an unmount of /dev, /proc, and /sys. It is fairly
useless in it's current state.

    $ athenry clean

###shell:
_________

    $ athenry shell

Is one of Athenry's most powerful features. This will allow you to run each
step of building a stage from an irb like shell. This makes going back and
copying newer configs or debugging an issue painless.

    $ athenry shell
    
    Type help for a list of commands:
    >>
    help
    Athenry Shell Help:
    ===================
    * help 
    * quit 

    Setup:
    ---------------
    * generate_bashscripts
    * stage
    * snapshot
    * copy_configs
    * copy_scripts


    Build:
    ---------------
    * install_overlays
    * etc_update
    * target
    * rebuild
    * update_everything
    * sync
    * install_sets
    * install_pkgmgr

    Target:
    ---------------
    * stage3
    * custom

    Freshen:
    ---------------
    * update

    Clean:
    ---------------
    * unmount
    >>

Notes
-----

Please refer to [about](http://gregf.github.com/athenry/about/) for more information on Athenry. It is still in
the very early stages of development and should not be relied upon for
production use.
