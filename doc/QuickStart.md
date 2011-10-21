Quickstart Guide
================

Quickstart Index
----------------

- [Where to download?](#where_to_download)
- [Installation](#installation)
- [Configuration](#configuration)
    - [Emerge](#emerge)
- [Usage](#usage)
- [Commands](#commands)
    - [setup](#setup)
    - [build](#build)
    - [target](#target)
    - [rescue](#rescue)
    - [resume](#resume)
    - [freshen](#freshen)
    - [clean](#clean)
- [shell](#shell)
- [Notes](#notes)

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

Athenry stores all configuration data in a plain text config file. During
Athenry's first installation, athenry.conf is copied to
/etc/athenry/athenry.conf. The default configuration options provided in
/etc/athenry/athenry.conf are sane defaults that the developers chose.
These settings should work for most anyone that would like to give Athenry a
try.

With that said, it is a good idea to review the config file to see if there are
configuration options that may work better for you such as the working
directory, your timezone, and even what mirrors to use. As the athenry.conf in
/etc are settings the developers consider sane defaults, it is highly recommend
that athenry.conf be copied to ~/.config/athenry/athenry.conf. Athenry actually
checks for ~/.config/athenry/athenry.conf for it's configuration settings
before looking in /etc/athenry/athenry.conf. All changes to Athenry's
configuration and settings should be made to this local configuration file.
That way /etc/athenry/athenry.conf will always be there for reference in case
you make a change and Athenry no longer does what is expected. Another detail
to keep in mind is every time Athenry is updated, /etc/athenry/athenry.conf is
overwritten with any new configuration options, deprecated options are removed,
any changes that the developers may think are better defaults now will be
updated. To put it simply, any personal changes made to the config in /etc will
be overwritten with Athenry's updated config.

The developers recommend that you update Athenry regularly, then diff the local
Athenry config file in ~/ to the Athenry config in /etc. Think of this as a
"manual" etc-update. This is an easy way to see what new features Athenry has,
any changes in how Athenry works, and any options or functions that have been
deprecated and/or removed

The following is the list of Athenry's currently sane defaults and available
settings.

###athenry.conf:
    [general]
    workdir = /var/tmp/athenry
    timezone = EST5EDT
    verbose = true
    arch = amd64

    [stage]
    url = http://gentoo.osuosl.org/releases/amd64/current-stage3/stage3-amd64-20100121.tar.bz2

    [snapshot]
    url = http://gentoo.osuosl.org/snapshots/portage-latest.tar.bz2

    [overlays]
    sunrise =
    mpd = git://github.com/gregf/mpd.git

    [gentoo]
    sync = rsync://rsync.gentoo.org/gentoo-portage
    sets = stage4 stage5
    package\_manager = paludis
    profile = default/linux/amd64/10.0


**workdir**
: This is the root directory where created stages, logs, the state file, and downloaded files will be stored.

**timezone**
: Timezone to be set for the chroot.

**verbose**
: Does just what it implies, toggles verbosity. Even with this set to
false you can tail the log file to see Athenry's progress.

**arch**
: This is the architecture you plan on building for.

**stageurl**
: This is the url where Athenry will grab the stage seed from.

**snapshoturl**
: This is the url where Athenry will grab the portage snapshot from.

**overlays**
: This takes a list of overlays you would like to use. You can optionally
specify an additional overlay url to be pulled in.

**sync**
: Sets the default rsync mirror for the portage tree.

**sets**
: A listing of set files to install. This is how packages to be installed
into the chroot are handled.

**package\_manager**
: This can be set to either paludis or emerge.

**profile**
: Default gentoo profile to use, this does not override configuration settings you may have set,
this is only to assure the make.profile symlink is set correctly.

###Emerge

The current stable version of emerge does not support sets. In order to build
custom stages with Athenry using emerge, versions >=2.2 will have to be unmasked.

This is a trival task. All that needs to be done is to add the following line to
package.unmask in the chroot that Athenry is using.

###package.unmask
    >=sys-apps/portage-2.2_rc33

The following documentation describes how to use sets in emerge;

1. [Portage Manual](http://dev.gentoo.org/~zmedico/portage/doc/ch02s03.html)
2. [Help writing /etc/portage/sets.conf](http://forums.gentoo.org/viewtopic-t-706642.html)
3. [Portage 2.2, the new features](http://forums.gentoo.org/viewtopic-p-5127806.html)
5. [Gentoo-User Discussion](http://www.linux-archive.org/gentoo-user/250682-portage-sets.html)
6. [Example Set File](http://github.com/gregf/athenryconfigs/blob/master/etc/amd64/portage/sets/stage4)


Usage
-----

  NAME:

    Athenry

  DESCRIPTION:

    Creates a Gentoo chroot and automates stage building

  COMMANDS:

    build                Executes a single command on the given chroot [command]
    clean                Cleans up any mess made [options]
    freshen              Updates an existing chroot
    help                 Display global or [command] help documentation.
    rescue               Chroot into the current stage to perform commands manually
    resume               Resume from last saved state
    setup                Fetches files and creates necessary directories
    shell                Run Athenry commands directly through an irb like shell
    target               Starts building the target stage specified

  GLOBAL OPTIONS:

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

The setup command does a number of things. It fetches the stage file and a
portage snapshot. It checks the md5sums of those files, and extracts them.
Creating the necessary directory structure for Athenry to properly operate.

Athenry automatically runs the setup process when any stage is built.
Alternatively you can run the `target setup` command to do just the setup
process. You can also run individual setup commands if you wish. For example:

    $ athenry setup fetchstage

**fetchstage**
: Fetches the stage from the stage url.

**extractstage**
: Extracts the stage tarball into your chroot while checking the md5sum.

**fetchsnapshot**
: Fetches the snapshot tarball.

**extractsnapshot**
: Extracts the snapshot tarball while checking the md5sum.

**updatesnapshot**
: If the snapshot cache has not been updated within 24 hours update it again using rsync.

**copysnapshot**
: Copies the snapshot cache into your chrootdir.

**copy\_scripts**
: Copies the scripts needed to build your stage into your chroot.

**copy\_configs**
: Copies user defined configuration files into your chroot for use.

###build:
_________

The build command is used for issuing single commands to the build process. For
example:

    $ athenry build install_pkgmgr

All commands run from build are performed inside the specified chroot. Here is
a list of commands that can be run.

**sync**
: Syncs the portage tree.

**install\_pkgmgr**
: Installs the package manager that has been set.

**update\_everything**
: Updates all packages in the specified chroot.

**etc\_update**
: Updates any out of date configuration files in the specified chroot.

**install\_overlays**
: Installs overlays that have been specified in athenry.conf

**install\_sets**
: Installs sets that have been specified in athenry.conf

**rebuild**
: Rebuilds packages with broken linkage, also runs python-updater.

###target:
__________

The target command is used to build an entire stage tarball in one swoop.
It runs setup if it has not already been run. It will then go through all the
necessary build steps in the correct order to build the specified stage.

    $ athenry target stage3

**setup**
: Runs commands necessary for initial setup.

**stage3**
: Builds a stage3.

**custom**
: Builds a custom stage using sets and overlays.

Currently stage3 and custom are the only stages supported. For now, the custom
target must be used if any sets or custom overlays are to be installed.

###rescue:
__________

Rescue is for when something goes wrong, and it will. Athenry tries to build
the specified stage in a way that won't cause headaches. With that said, there
are always problems that can occur. Since building a stage1 is currently not
supported, the rescue command is offered. This command simply chroots into the
specified chroot dir and allows any blockages or other issues that may have
happened to be fixed. Athenry can then resume from where the problem occured.

    $ athenry rescue

###resume:
__________

The resume command should pick up where Athenry left off. Resuming can only be
done from a target command.

    $ athenry resume

###freshen:
___________

Freshen will update the specified chroot.

    $ athenry freshen

###clean:
_________

The clean command currently only performs an unmount of /dev, /proc, and /sys.
It is fairly useless in it's current state.

    $ athenry clean

###shell:
_________

    $ athenry shell

The shell command is one of Athenry's most powerful features. This will allow
you to run each step of building a stage from an irb like shell. This makes
going back and copying newer configs or debugging an issue painless.  Commands
are tab completed using ruby readline.

Notes
-----

Please refer to [about](http://gregf.github.com/athenry/about/) for more
information on Athenry. Athenry is still in the very early stages of
development and should not be relied upon for production use.
