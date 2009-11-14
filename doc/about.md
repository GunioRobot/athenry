About
======

Why Athenry? (Áth na Rí)
------------------------

Why Athenry when there are already two other rather mature tools available,
[Metro](http://github.com/funtoo/metro/tree/master) and
[Catalyst](http://www.gentoo.org/proj/en/releng/catalyst/). Each of these tools
do fine jobs, and continue to do the job the devs want in producing usable
stage tarballs. Athenry does not try to be Catalyst or Metro. With previous
attempts to use both tools, it became obvious that there are advantages, and
short comings for both tools. Athenry was created in an attempt to take the
best from both Metro and Catalyst, and leaving behind anything that makes it
more difficult to create any stage tarballs that are needed. Athenry allows the
ability to resume from any point of failure, instead of having to start all
over again from scratch. Athenry is package manager agnostic. Use the package
manager of your choice. This is discussed more in depth below. Atherny starts
with a chroot just like what would have to be done manually with other tools
before beginning. A stage tarball is downloaded if not already present, and the
files extracted.  Athenry's configuration files are pulled into the chroot. You
are free to use the config files as is, or tweak and edit until your fingers
are sore. Now that Athenry has the information it needs, it will go through the
steps needed to produce a working chroot or stage tarball of your choice, built
to your exacting specifications. If after examining Athenry's output, and
everything is exactly what was expected, Athenry can now create as many
chroot's or stage tarballs as needed without further modification.

One of the main reasons for writing Athenry was neither Catalyst nor Metro
allowed a package manager beside emerge to be used. As the ever increasing
number of [Paludis](http://paludis.pioto.org/) users grow, the need for a
system to easily build chroots and stage tarballs using their package manager
of choice also increases. Athenry has been written with the idea of staying
package manager agnostic in mind.  Currently, there is support for emerge and
paludis out of the box. None of Athenry's devs uses
[pkgcore](http://www.pkgcore.org/trac/pkgcore), or support for pkgcore would be
included as well.  Adding pkgcore support should be a trivial task if someone
was interested enough to do the testing.

There weren't any benefits, besides the "coolness" factor, in moving all
configuration into a
[DSL](http://en.wikipedia.org/wiki/Domain-specific_language), when most of us
have already spent a great deal of time building, tweaking and perfecting
configuration files. The decision in building the stages in a chroot allows
easy recovery in the event Athenry is having issues building a stage for some
reason. Once the error is discovered one can simply chroot into the stage
building environment, fix any errors encountered, log out and then let Athenry
continue from that point like nothing even happened. Something both catalyst
and metro have neglected.

Athenry is currently at a very early stage of development, and It is not
recommend that most people play with it just yet. If you are curious, or find
it useful feel free to try. Large chunks of code are ugly and are going to be
refactored. There is also a great deal of missing functionality that is coming
with the next release.  The point of releasing Athenry now is to get some
people using it that can hopefully handle any potential bugs and to receive
feedback.

The Athenry team has the utmost respect for the [Gentoo](http://www.gentoo.org)
and [Funtoo](http://www.funtoo.org) teams. We are however unhappy with how
existing tools work now. We hope everyone enjoys Athenry, but if no one else
but the team finds it usefull it, is still worth the effort in the end.
