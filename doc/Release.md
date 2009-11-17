Creating A Release
==================

Steps
-----

* Make sure documentation has been updated
* Edit athenry/lib/version.rb
* git checkout master
* git merge next
* git tag -a v0.1a "Creating official version"
* git push --tags
* git checkout -b v0.1a
* git push --all
* Update wiki
