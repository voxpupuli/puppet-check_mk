# check_mk

[![License](https://img.shields.io/github/license/voxpupuli/puppet-check_mk.svg)](https://github.com/voxpupuli/puppet-check_mk/blob/master/LICENSE)
[![Build Status](https://travis-ci.com/voxpupuli/puppet-check_mk.png?branch=master)](https://travis-ci.com/voxpupuli/puppet-check_mk)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/check_mk.svg)](https://forge.puppetlabs.com/puppet/check_mk)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/check_mk.svg)](https://forge.puppetlabs.com/puppet/check_mk)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/check_mk.svg)](https://forge.puppetlabs.com/puppet/check_mk)

## Description
The module installs and configures the Open Monitoring Distribution (OMD) which includes Nagios, check_mk and lots of other tools. Beside the server component, the module is also able to install and configure the check_mk agent.

Originally by [erwbgy](https://forge.puppet.com/erwbgy), then forked by [gnúbila France](https://forge.puppet.com/gnubilafrance) and now maintained by [Vox Pupuli](https://voxpupuli.org).

## Setup
The module has been tested with:
  * CentOS 6 and 7;
  * Debian 8 and 9;
  * Puppet version 5 and Puppet 6;
  * check_mk version 1.5.x.

Also it requires the following forge modules:
  * puppetlabs/concat
  * puppetlabs/stdlib
  * camptocamp/systemd

## Usage
### Server
#### Basic usage
The following code will install check_mk and create one 'omd site'. Once this is done you should be able to access it by visiting:

```http://<IP of the machine>/monitoring/```

Debian 9:
```puppet
class { 'check_mk':
  filestore => 'https://mathias-kettner.de/support/1.5.0p19/',
  package   => 'check-mk-raw-1.5.0p19_0.stretch_amd64.deb',
}
```

CentOS 7:
```puppet
class { 'check_mk':
  filestore => 'https://mathias-kettner.de/support/1.5.0p19/',
  package   => 'check-mk-raw-1.5.0p19-el7-38.x86_64.rpm',
}
```

Before you are able to login you have to reset the default admin password:

```
su - monitoring
htpasswd -i ~/etc/passwd cmkadmin
```

#### Changing default site name
The following example changes the default site name from 'monitoring' to 'differentsitename'
```puppet
class { 'check_mk':
  site => 'differentsitename',
}
```

#### Without direct internet access
For machines without direct internet connection a different 'filestore' is required. First download [the required installation files](https://checkmk.com/download.php?) on a machine with direct internet access and move the file onto the system (for example to: '/tmp').

```puppet
class { 'check_mk':
  filestore => '/tmp',
  package   => 'check-mk-raw-1.5.0p19-el7-38.x86_64.rpm',
}
```

The [puppet fileserver](https://puppet.com/docs/puppet/6.6/file_serving.html) can also be used.

```puppet
class { 'check_mk':
  filestore => 'puppet:///<NAME OF MOUNT POINT>',
  package   => 'check-mk-raw-1.5.0p19-el7-38.x86_64.rpm',
}
```

### Agent
#### Basic usage
To install the check_mk agent a check_mk server needs to be up and running. Because the check_mk server will be used as a distribution point for the agent package.

Debian 9:
```puppet
class { 'check_mk::agent':
  filestore => 'http://<url of the check_mk server>/monitoring/check_mk/agents/',
  package   => 'check-mk-agent_1.5.0p19-1_all.deb',
}
```

CentOS 7:
```puppet
class { 'check_mk::agent':
  filestore => 'http://<url of the check_mk server>/monitoring/check_mk/agents/',
  package   => 'check-mk-agent-1.5.0p19-1.noarch.rpm',
}
```

#### Securing agent
The agent has the ability to implement a whitelist of check_mk servers to limited access only to those servers. To increase the security of the check_mk agent you can implement the following:
  * Encrypt communication with a secret. See [the check_mk website](https://checkmk.com/cms_agent_linux.html#encryption) for more information.
  * Implement whitelisting on the agent.
  * Implement a strict incoming firewall which only allows access on port 6556 from the check_mk server. The firewall can be configured using the [puppetlabs/firewall](https://forge.puppet.com/puppetlabs/firewall) module.

The following code implements a whitelist and a communication secret:

```puppet
class { 'check_mk::agent':
  ip_whitelist      => ['10.0.0.1'],
  encryption_secret => 'SECRET',
}
```
