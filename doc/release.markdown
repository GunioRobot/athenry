Creating A Release
==================

Steps
-----

* git checkout master
* git tag -a v0.1a "Creating official version"
* git push --tags
* git push gh --tags
* git checkout -b v0.1a
* git push --all
* git push gh --all
* rake build:tar
* mv athenry-latest.tar.bz2 ~/athenry-v0.1a.tar.bz2
* Upload to github's downloads section
