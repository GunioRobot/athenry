Quickstart Guide
================

Where to download?
------------------

The best way to get Athenry is to check out the latest release branch from
github.

    git clone git://github.com/gregf/athenry.git athenry

Installation
------------

After checking out a fresh copy of Athenry from git or extracting a previously
downloaded tarball, Athenry needs to be installed. To install Athenry run
install.rb.

    cd athenry
    ./install.rb

Configuration
-------------

Athenry stores all configuration data in a plain text yaml file. During
Athenry's first installation, config.yml.example is copied to
/etc/athenry/config.yml.example.  Athenry will not run until this file is
reviewed and then renamed to config.yml. The default configuration options
provided in /etc/athenry/config.yml are sane defaults that the developers
chose. These settings should work for most anyone that would like to give
Athenry a try. With that said, it is a good idea to review the config file to
see if there are configuration options that may work better for you such as the
working directory, your timezone, and even what mirrors to use. As the
config.yml in etc are settings the developers consider sane defaults, it is
highly recommend that config.yml be copied to $HOME/.config/athenry/config.yml.
Athenry actually checks for $HOME/.config/athenry/config.yml for it's
configuration settings before looking in /etc/athenry/config.yml. All changes
to Athenry's configuration and settings should be made to t his local
configuration file. That way /etc/athenry/config.yml will always be there for
reference in case you make a change and Athenry no longer does what is
expected. Another detail to keep in mind is every time Athenry is updated,
/etc/athenry/config.yml is overwritten with any new configuration options,
deprecated options are removed, any changes that the devs may think are better
defaults now will be updated. To put it simply, any personal changes made to
the config in etc will be overwritten with Athenry's updated  config. The
developers recommend that you update Athenry regularly, then diff the local
Athenry config file in $HOME to the Athenry config in etc. Think of this as a
"manual" etc-update. This is an easy way to see what new features Athenry has,
any changes in how Athenry works, and any options or functions that have been
deprecated and/or removed.

The following is the list of Athenry's currently sane defaults and available
settings.

`config.yml`

    workdir: "/var/tmp/athenry"
    chrootdir: "stage5"
    configs: "#{ENV['home']}/.config/athenry"
    stageurl: "http://mirrors.kernel.org/gentoo/releases/amd64/autobuilds/current-stage3/stage3-amd64-20091029.tar.bz2"
    snapshoturl: "http://gentoo.osuosl.org/snapshots/portage-latest.tar.bz2"
    verbose: "true"
    logfile: "/var/log/athenry.log"
    overlays: [sunrise mpd]
    pkgmanager: "paludis" #or emerge
    sets: [stage4]
    timezone: "EST5EDT"

**workdir**: This is the root directory where created stages, logs, the state file, and downloaded files will be stored.

**chrootdir**: Relative path to the work dir, where the chroot will be built.

**configs**: This should point to the directory where config.yml is kept. These
files are used for building the chroot. Athenry will blindly copy files to
chrootdir/etc recursivley.

**stageurl**: This is the url where Athenry will grab the stage seed from.

**snapshoturl**: This is the url where Athenry will grab the portage snapshot from.

**verbose**: Does just what it implies, toggles verbosity. Even with this set to
false you can tail the log file to see the progress.

**logfile**: If a filename is set it logs to logdir/logfile, if blank logging is
disabled.

**overlays**: This takes an array of overlays you would like to use. Currently
does not build the overlay configuration for you, You are expected to have
required configurations copied in with the configs setting. This will use
playman/layman in the future.

**pkgmanager**: This can be set to either paludis or emerge. pkgcore could be
added with relative ease if requested and someone was interested enough to do
testing. The only reason pkgcore is not supported by default is no Athenry devs
currently use it.

**sets**: An array listing set files to install. This is how packages to be
installed into the chroot is handled.

**timezone**: Timezone to be set for the chroot.  Usage

Usage
-----

    athenry --help
    NAME:

    Athenry

    DESCRIPTION:

    Creates a Gentoo chroot and automates stage building

    SUB-COMMANDS:

    help                 Display help documentation for <sub_command>
    build                Starts the build process
    resume               Resume from last successful state
    shell                Run Athenry commands directly through an irb like shell
    setup                Fetches files and creates necessary directories
    clean                Cleans up Athenry's mess

    GLOBAL OPTIONS:

    -h, --help
        Display help documentation

    -v, --version
        Display version information

    -t, --trace
        Display a backtrace when an error occurs

Currently the workflow would be to run commands in the following order.

    athenry setup
    athenry build

If there is a failure or have the need to stop and come back later run

    athenry resume

This should pick up where Athenry left off. Currently there is a small
limitation on resume support. If Athenry is stopped at the last step of setup
Athenry will not know to start running build. This will be resolved in a future
release.

    athenry clean

Currently only performs an unmount of /dev, /proc, and /sys. It is fairly
useless in it's current state.

    athenry shell

Is one of athenry's most powerful features. This will allow you to run each
step of building a stage from an irb like shell. This makes going back and
copying newer configs or debugging an issue painless.

    athenry shell

    Type help for a list of commands:
    >>
    help
    Athenry Shell Help:
    ===================
    help - displays this
    quit - quits

    Setup:
    ---------------
    fetch
    extract
    snapshot
    generate_bashscripts
    copy_scripts
    copy_configs

    Build:
    ---------------
    mount
    chroot

    Resume:
    ---------------
    continue

    Clean:
    ---------------
    umount
    >>

Note
----

Please refer to {file:about} for more information on Athenry. It is still in
the very early stages of development and should not be relied upon for
production use.
