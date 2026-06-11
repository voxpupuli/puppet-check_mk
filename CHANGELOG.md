# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [Unreleased](https://github.com/voxpupuli/puppet-check_mk/tree/HEAD)

[Full Changelog](https://github.com/voxpupuli/puppet-check_mk/compare/v0.10.0...HEAD)

**Breaking changes:**

- Drop Support for Agent Config Port and IP Whitelist [\#57](https://github.com/voxpupuli/puppet-check_mk/issues/57)
- Drop Support for Ubuntu 18.04 [\#54](https://github.com/voxpupuli/puppet-check_mk/issues/54)
- Drop Support for Debian 9 [\#53](https://github.com/voxpupuli/puppet-check_mk/issues/53)
- drop Ubuntu 20 [\#87](https://github.com/voxpupuli/puppet-check_mk/pull/87) ([marcusdots](https://github.com/marcusdots))
- drop el7, el8 [\#86](https://github.com/voxpupuli/puppet-check_mk/pull/86) ([marcusdots](https://github.com/marcusdots))
- checkmk-agent download URL, drop Debian-11 [\#84](https://github.com/voxpupuli/puppet-check_mk/pull/84) ([marcusdots](https://github.com/marcusdots))
- Drop puppet, update openvox minimum version to 8.19 [\#80](https://github.com/voxpupuli/puppet-check_mk/pull/80) ([TheMeier](https://github.com/TheMeier))
- Refactor Module to Support Uptodate CheckMK and OSes [\#51](https://github.com/voxpupuli/puppet-check_mk/pull/51) ([voxel01](https://github.com/voxel01))
- Drop Puppet 6 support [\#50](https://github.com/voxpupuli/puppet-check_mk/pull/50) ([bastelfreak](https://github.com/bastelfreak))
- Drop Puppet 5 support; require 6.1.0 or newer [\#44](https://github.com/voxpupuli/puppet-check_mk/pull/44) ([bastelfreak](https://github.com/bastelfreak))
- Drop EOL CentOS 6/xinetd support [\#43](https://github.com/voxpupuli/puppet-check_mk/pull/43) ([bastelfreak](https://github.com/bastelfreak))
- Drop EOL Debian 8 support [\#36](https://github.com/voxpupuli/puppet-check_mk/pull/36) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Add Support for Debian 10, 11 [\#56](https://github.com/voxpupuli/puppet-check_mk/issues/56)
- Add Support for Ubuntu 20.04 and 22.04 [\#55](https://github.com/voxpupuli/puppet-check_mk/issues/55)
- Add Support for RHEL/CentOS 8 and 9 [\#52](https://github.com/voxpupuli/puppet-check_mk/issues/52)
- allow puppet-systemd 9.x [\#91](https://github.com/voxpupuli/puppet-check_mk/pull/91) ([marcusdots](https://github.com/marcusdots))
- allow puppetlabs-concat 10.x [\#90](https://github.com/voxpupuli/puppet-check_mk/pull/90) ([marcusdots](https://github.com/marcusdots))
- add Debian13, Ubuntu22, Ubuntu24 [\#89](https://github.com/voxpupuli/puppet-check_mk/pull/89) ([marcusdots](https://github.com/marcusdots))
- add el10, rocky10, alma10 [\#88](https://github.com/voxpupuli/puppet-check_mk/pull/88) ([marcusdots](https://github.com/marcusdots))
- Add support for Debian 12 [\#82](https://github.com/voxpupuli/puppet-check_mk/pull/82) ([smortex](https://github.com/smortex))
- metadata.json: Add OpenVox [\#76](https://github.com/voxpupuli/puppet-check_mk/pull/76) ([jstraw](https://github.com/jstraw))
- puppet/systemd: Allow 6.x [\#65](https://github.com/voxpupuli/puppet-check_mk/pull/65) ([zilchms](https://github.com/zilchms))
- puppetlabs/concat: Allow 9.x [\#64](https://github.com/voxpupuli/puppet-check_mk/pull/64) ([zilchms](https://github.com/zilchms))
- Add Puppet 8 support [\#60](https://github.com/voxpupuli/puppet-check_mk/pull/60) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/stdlib: Allow 9.x [\#59](https://github.com/voxpupuli/puppet-check_mk/pull/59) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Fix Acceptence Tests [\#58](https://github.com/voxpupuli/puppet-check_mk/issues/58)

**Merged pull requests:**

- puppet/systemd: allow 8.x [\#74](https://github.com/voxpupuli/puppet-check_mk/pull/74) ([jay7x](https://github.com/jay7x))
- update puppet-systemd upper bound to 8.0.0 [\#68](https://github.com/voxpupuli/puppet-check_mk/pull/68) ([TheMeier](https://github.com/TheMeier))
- cleanup .fixtures.yml [\#47](https://github.com/voxpupuli/puppet-check_mk/pull/47) ([bastelfreak](https://github.com/bastelfreak))
- Allow stdlib 8.0.0 [\#46](https://github.com/voxpupuli/puppet-check_mk/pull/46) ([smortex](https://github.com/smortex))
- switch from camptocamp/systemd to voxpupuli/systemd [\#45](https://github.com/voxpupuli/puppet-check_mk/pull/45) ([bastelfreak](https://github.com/bastelfreak))

## [v0.10.0](https://github.com/voxpupuli/puppet-check_mk/tree/v0.10.0) (2020-09-19)

[Full Changelog](https://github.com/voxpupuli/puppet-check_mk/compare/v0.9.1...v0.10.0)

0.10.0 is the last release with Debian 8 support! the next release will be 1.0.0 without support for the EOL Debian 8.

**Merged pull requests:**

- modulesync 3.0.0 & puppet-lint updates [\#32](https://github.com/voxpupuli/puppet-check_mk/pull/32) ([bastelfreak](https://github.com/bastelfreak))
- Use voxpupuli-acceptance [\#31](https://github.com/voxpupuli/puppet-check_mk/pull/31) ([ekohl](https://github.com/ekohl))

## [v0.9.1](https://github.com/voxpupuli/puppet-check_mk/tree/v0.9.1) (2020-01-13)

[Full Changelog](https://github.com/voxpupuli/puppet-check_mk/compare/v0.9.0...v0.9.1)

Version 0.9.0 failed to deploy to the puppet forge. This is a re-release with no changes (other than updated travis secret).

**Merged pull requests:**

- Fix travis puppetforge secret [\#27](https://github.com/voxpupuli/puppet-check_mk/pull/27) ([alexjfisher](https://github.com/alexjfisher))

## [v0.9.0](https://github.com/voxpupuli/puppet-check_mk/tree/v0.9.0) (2020-01-10)

[Full Changelog](https://github.com/voxpupuli/puppet-check_mk/compare/v0.8.1...v0.9.0)

**Breaking changes:**

- Remove support for EOL operating systems [\#21](https://github.com/voxpupuli/puppet-check_mk/pull/21) ([alexjfisher](https://github.com/alexjfisher))

**Implemented enhancements:**

- Add `package_ensure` parameter to agent class [\#25](https://github.com/voxpupuli/puppet-check_mk/pull/25) ([alexjfisher](https://github.com/alexjfisher))
- Add `service_name` parameter to agent class [\#22](https://github.com/voxpupuli/puppet-check_mk/pull/22) ([mmerfort](https://github.com/mmerfort))

**Closed issues:**

- Migrate module to vox pupuli [\#1](https://github.com/voxpupuli/puppet-check_mk/issues/1)

## [v0.8.1](https://github.com/voxpupuli/puppet-check_mk/tree/v0.8.1) (2019-07-27)

[Full Changelog](https://github.com/voxpupuli/puppet-check_mk/compare/v0.8.0...v0.8.1)

Version 0.8.0 failed to deploy to the puppet forge.  This is a re-release with no other changes.

## [v0.8.0](https://github.com/voxpupuli/puppet-check_mk/tree/v0.8.0) (2019-07-27)

[Full Changelog](https://github.com/voxpupuli/puppet-check_mk/compare/0.7.2...v0.8.0)

This is the first release of this module under [Vox Pupuli](https://voxpupuli.org/)'s [`puppet`](https://forge.puppet.com/puppet) namespace.  The module has been modernised and only puppet 5 and up are supported.  It has been developed and tested with check_mk 1.5 [raw edition](https://checkmk.com/editions.html).  Earlier versions may not work.

Support for End Of Life operating systems will be removed after this release.

**Implemented enhancements:**

- Support check\_mk agents 1.5+ and systemd based agent configuration [\#10](https://github.com/voxpupuli/puppet-check_mk/pull/10) ([alexjfisher](https://github.com/alexjfisher))

**Fixed bugs:**

- Fix RedHat agent `config_dir` and test and fix `encryption_secret` [\#12](https://github.com/voxpupuli/puppet-check_mk/pull/12) ([alexjfisher](https://github.com/alexjfisher))

**Merged pull requests:**

- Updating README [\#14](https://github.com/voxpupuli/puppet-check_mk/pull/14) ([zyronix](https://github.com/zyronix))
- Replace `create_resources` with iteration [\#13](https://github.com/voxpupuli/puppet-check_mk/pull/13) ([alexjfisher](https://github.com/alexjfisher))
- Allow `puppetlabs` `stdlib` and `concat` 6.x [\#11](https://github.com/voxpupuli/puppet-check_mk/pull/11) ([alexjfisher](https://github.com/alexjfisher))
- Acceptance tests [\#8](https://github.com/voxpupuli/puppet-check_mk/pull/8) ([zyronix](https://github.com/zyronix))
- Support check\_mk 1.5+ [\#6](https://github.com/voxpupuli/puppet-check_mk/pull/6) ([zyronix](https://github.com/zyronix))
- Remove `install_tarball` class and tests [\#5](https://github.com/voxpupuli/puppet-check_mk/pull/5) ([alexjfisher](https://github.com/alexjfisher))
- Fix rubocop violations [\#4](https://github.com/voxpupuli/puppet-check_mk/pull/4) ([alexjfisher](https://github.com/alexjfisher))
- Vox Pupuli migration [\#2](https://github.com/voxpupuli/puppet-check_mk/pull/2) ([alexjfisher](https://github.com/alexjfisher))

## [0.7.2](https://github.com/voxpupuli/puppet-check_mk/tree/0.7.2) (2018-01-17)

[Full Changelog](https://github.com/voxpupuli/puppet-check_mk/compare/v0.7.2...0.7.2)

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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
