Athenry
========

**Homepage**:   [http://gregf.github.com/athenry/](http://gregf.github.com/athenry/)  
**Git**:        [http://github.com/gregf/athenry](http://github.com/gregf/athenry)  
**Author**:     Greg Fitzgerald  
**Copyright**:  2009  
**License**:    MIT License  

DESCRIPTION
--------------

Athenry tries to stay as simple as possible to do a complex job. It will take
your system configuration files from /etc and build gentoo stages. 

For more information please refer to {file:about.markdown}.

REQUIREMENTS
-------------
Install the following gems:  

    $ gem sources -a http://gems.github.com
    $ sudo gem install configatron
    $ sudo gem install visionmedia-commander 

* [configatron](http://github.com/markbates/configatron/tree/master)  
* [visionmedia-commander](http://github.com/visionmedia/commander/tree/master)  

INSTALLATION
------------

See {file:quickstart.markdown}.

DOCUMENTATION
-------------
You can build the documentation by running  

    $ rake documentation:generate

Files generated will be stored inside meta/documentation

CREDITS
--------

See {file:AUTHORS.markdown}.

ROADMAP
--------

See {file:TODO.markdown}.

CHANGELOG
---------
- **Sept.10.09** v0.1a release. Initial alpha release for testing, can build stage4 and stage5's from a stage3. Basic resume support. 

COPYRIGHT
---------

Athenry &copy; 2009 by [Greg Fitzgerald](mailto:netzdamon@gmail.com). Licensed under the MIT 
license. Please see the {file:MIT-LICENSE} for more information.

