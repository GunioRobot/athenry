Hacking
========

Notes for working on Athenry
----------------------------

Just some general notes before hacking away, if you make changes to
functionality make sure code comments and documentation reflect this before you
push.

Git
---

Never work in the master branch this is for stable releases. Checkout next for
current changes. If your patch is going to be a major deviation you may want to
create another branch to merge from. Next is a moving target.

Releases
--------

See {file:release.markdown}.

Restraints for working with ruby
--------------------------------

These restraints are mostly in place to keep code clean and consistent:

* Set vim to use ts=2 sw=2 noet, or equivalents in your editor
* variables should be singled quoted '' unless double quotes "" are need for evaluation
* Methods using more than two or more options, or long strings should be surrounded in ()
* Stick to use cmd method rather than FileUtils for consistency
* Code for ruby 1.9 in mind when possible

Restraints for working with bash
--------------------------------

In order to stay posix compliant the following constraints should be enforced: 

* Set vim to use ts=4 sw=4 noet, or equivalents in your editor
* variables should be quoted and bracketed "${SOMEVAR}"
* inline execution should be done with $() instead of backticks
* use -z "${var}" to test for nulls/empty strings
* incase of embedded spaces, quote all path names and string comarpisons


On top of these we assume all systems are currently using Bash 3x. Do not use Bash 4x features.
