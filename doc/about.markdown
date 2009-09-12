About
==========

Why Athenry?
------------

Why bother with learning another tool when there are already two other much more
mature tools avialible, [metro](http://github.com/funtoo/metro/tree/master) and
[catalyst](http://www.gentoo.org/proj/en/releng/catalyst/)? Athenry doesn't try
to be catalyst or metro. Atherny will build a chroot just like you would do if
you were doing the steps manually. It extracts, a stage file, it copies your
configuration files in, then will go through the steps to produce a working
chroot or stage tarball. 

I don't belive in moving all configuration into a
[DSL](http://en.wikipedia.org/wiki/Domain-specific_language) when I have already
spent time building config files in my daily use. I also feel building the
stages in a chroot allows easy recovery in the event Athenry is having issues
building a stage. Something both catalyst and metro have neglected. The final
reason for me writting Athenry was neither catalyst or metro allow package
managers outside emerge. As a [Paludis](http://paludis.pioto.org/) user I want
my system to use my tool of choice. Athenry tries to stay package manager
agnostic. Currently supports emerge and paludis out of the box. Adding
[pkgcore](http://www.pkgcore.org/trac/pkgcore) should be a trival task. 

Having said this. Athenry is currently at a very early stage and I would not
recommend most people play with it just yet. Big chunks of code are ugly and it
is missing chunks of functionality. Point of releasing now is to get some people
using it to and to receive any feedback. 

I have the at most respect for the [Gentoo](http://www.gentoo.org) team and
[Funtoo](http://www.funtoo.org) team. I am however unhappy with how existing
tools work, and if no one else but me enjoys Athenry it is still worth the
effort in the end.
