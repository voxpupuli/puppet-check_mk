## v0.7.2 (2018-01-17)

* puppet-concat 4 compatibility

## v0.7.1 (2016-03-14)

* Add check_mk::agent::mrpe, code from Bas Grolleman contributed by gerhardsam.

## v0.7.0 (2016-03-08)

* Rework of check_mk::agent classes, contributed by gerhardsam.

## v0.6.2 (2016-03-07)

* Add rspec tests contributed by gerhardsam.

## v0.4.0

* Fix all_hosts_static.erb, update xinetd on wheezy and use cron instead of a
scheduled exec.
* Package a new version as upstream seems unmaintained.

## v0.3.0

* Added host tags to agent config so that host groups can be auto-populated
* Fixed incorrect package name when using a file store that was causing the
package existence check to fail always causing an often failing reinstall
* Enable a static list of hosts to be specified for those without the Puppet
check_mk module installed

## v0.2.0

* Switched to using OMD rather than manually compiling check_mk
* Added support for host tags and creating host groups based on these tags
* Allow local check_mk configuration to be specified in
/etc/check_mk/main.mk.local that is appended to /etc/check_mk/main.mk as
check_mk can do a lot more than is covered by this module

## v0.1.1

* Brown paper bag release to fix a silly typo

## 0.1

* Initial release
