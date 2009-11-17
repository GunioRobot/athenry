Athenry
========

**Homepage**:   [http://gregf.github.com/athenry] (http://gregf.github.com/athenry)  
**Git**:        [http://github.com/gregf/athenry] (http://github.com/gregf/athenry)  
**Author**:     Greg Fitzgerald  
**Copyright**:  2009  
**License**:    MIT License

DESCRIPTION
------------

Athenry will use the system configuration files you provide, to build what ever
Gentoo Stage tarballs (currently stage3 - stage5) you want to make installing
your own freshly rolled x86, amd64 for those computers at home and the friends
that have been bugging you, or even if you need something for work like, sparc,
PPC, ia64, all inside the safety of a single chroot, and using only Athenry.

For more information please refer to {file:about}.

REQUIREMENTS
-------------
Install the following gems:  

    gem sources -a http://gemcutter.org
    sudo gem install configatron
    sudo gem install commander 

* [configatron](http://github.com/markbates/configatron/tree/master)  
* [commander](http://github.com/visionmedia/commander/tree/master)  

INSTALLATION
------------

See the {file:QuickStart} guide.

DOCUMENTATION
-------------
You can build the documentation by running  

    rake documentation:generate

Files generated will be stored inside meta/documentation

CREDITS
--------

See {file:AUTHORS}.

ROADMAP
--------

See {file:TODO}.

HACKING
-------

See {file:Hacking}.

HISTORY
---------
See {file:History}.

COPYRIGHT
---------

Athenry &copy; 2009 by [Greg Fitzgerald](mailto:netzdamon@gmail.com). Licensed under the MIT 
license. Please see the {file:MIT-LICENSE} for more information.
