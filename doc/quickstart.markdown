Quickstart Guide
================

Where to get?
------------

Best way to grab athenry is to check out the latest release branch github.

    $ git clone git://github.com/gregf/athenry.git
    $ git checkout v0.1a

Configuration
-------------

Configuration is currently stored in a yaml file. This is staged to change in
v0.2 to be much more clear. I'll walk through each setting below.

`config.yml`

    workdir: "/storage/staging"
    chrootdir: "stage5"
    configs: "/storage/athenry/etc/amd64"
    stageurl: "http://mirrors.kernel.org/gentoo/releases/amd64/autobuilds/current-stage3/stage3-amd64-20090903.tar.bz2"
    snapshoturl: "http://gentoo.osuosl.org/snapshots/portage-latest.tar.bz2"
    verbose: "true"
    logdir: "log"
    logfile: "athenry.log"
    overlays: [gregf mpd]
    pkgmanager: "paludis" #or emerge
    sets: [stage4]
    statedir: ".athenry"
    statefile: "state"
    timezone: "EST5EDT"

**workdir**: This is the directory the root directory that your stages, logs,
state file, and downloaded files will be stored.  

**chrootdir**: Relative path to where the chroot will be built.  

**configs**: This can point to any location, you'll want to store your config
files used for building the chroot here. Blindly copies files to chrootdir/etc
recursivley.  

**stageurl**: This optional setting downloads a seed stage3 to be used in our
chroot. As mentioned you can ignore this if you have already placed a stage3 in
your workdir.  

**verbose**: Does what it implies, toggles verbose level. Even with this set to
false you can tail the log file to see the progress.  

**logdir**: Relative path to where logfiles are stored inside workdir.  

**logfile**: If a filename is set it logs to logdir/logfile, if blank logging is
disabled.  

**overlays**: This takes an array of overlays you would like to use. Currently
does not build the overlay configuration for you, You are expected to have
required configuration copied in with the configs setting. This will use
layman/playman in the future.  

**pkgmanager**: This can be set to either paludis or emerge. pkgcore could be
added with relative ease if someone was interested enough to do testing.

**sets**: An array listing set files to install, this is how we handle listing
packages to be installed into our chroot.  

**statedir**: Relative path to statedir that is stored inside workdir  

**statefile**: Name of statefile stored in statedir

**timezone**: Timezone to be set for your chroot.

Usage
-----

    $ cd athenry/bin
    $ ./athenry --help
    NAME:

    Athenry 

    DESCRIPTION:

    Creates a Gentoo chroot and automates stage building

    SUB-COMMANDS:

    help                 Display help documentation for <sub_command>
    build                Starts the build process
    resume               Resume from last state
    shell                Run athenry commands directly through irb like shell
    setup                Fetches files and creates necessary directories
    clean                Cleans up our mess

    GLOBAL OPTIONS:

    -h, --help
        Display help documentation

    -v, --version
        Display version information

    -t, --trace
        Display backtrace when an error occurs

Currently the workflow would be to run commands in the following order.

    $ ./athenry setup
    $ ./athenry build

If there is a failure or you need to stop and come back later you can run

    $ ./athenry resume

This should pick up where you left off. Currently there is a small limitation on
resume support. If you leave off at the last step of setup it will not know to
start running build. This will be resolved in future releases.

    $ ./athenry clean

Currently only performs an unmount of /dev, /proc, and /sys. It is fairly
useless in it's current state.

    $ ./athenry shell

Is one of athenry's most powerful features. This will allow you to run each
step of building a stage from a irb like shell. This makes going back and
copying newer configs or debugging an issue painless.

    $ ./athenry shell
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

Please refer to {file:about.markdown} for more information on Athenry. It is still in the
very early stages and should not be relied upon. 
