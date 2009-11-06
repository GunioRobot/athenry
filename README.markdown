Athenry
========

**Homepage**:   [http://github.com/gregf/athenry] (http://github.com/gregf/athenry)  
**Git**:        [git://github.com/gregf/athenry.git] (git://github.com/gregf/athenry.git)  
**Author**:     Greg Fitzgerald  
**Copyright**:  2009  
**License**:    {file:MIT-LICENSE}  

DESCRIPTION
------------

Athenry will use the system configuration files you provide, to build what ever
Gentoo Stage tarballs (currently stage3 - stage5) you want to make installing
your own freshly rolled x86, amd64 for those computers at home and the friends
that have been bugging you, or even if you need something for work like, sparc,
PPC, ia64, all inside the safety of a single chroot, and using only Athenry.

For more information please refer to {file:about.markdown}.

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

See {file:quickstart.markdown}.

DOCUMENTATION
-------------
You can build the documentation by running  

    rake documentation:generate

Files generated will be stored inside meta/documentation

CREDITS
--------

See {file:AUTHORS.markdown}.

ROADMAP
--------

See {file:TODO.markdown}.

CHANGELOG
---------
- **Nov.10.06** v0.1a release. Initial alpha release for testing, can build stage4 and stage5's from a stage3. Basic resume support. 

COPYRIGHT
---------

Athenry &copy; 2009 by [Greg Fitzgerald](mailto:netzdamon@gmail.com). Licensed under the MIT 
license. Please see the {file:MIT-LICENSE} for more information.
