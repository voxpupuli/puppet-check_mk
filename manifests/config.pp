# Class: check_mk::config
#
# @summary Configures check_mk.
# @api private
#

class check_mk::config (
  String $site,
  Optional[Hash] $host_groups = undef,
  Optional[Array] $all_hosts_static = undef,
) {
  $etc_dir = "/omd/sites/${site}/etc"
  $bin_dir = "/omd/sites/${site}/bin"
  file { "${etc_dir}/nagios/local":
    ensure => directory,
    owner  => $site,
    group  => $site,
  }

  file_line { 'nagios-add-check_mk-cfg_dir':
    ensure  => present,
    line    => "cfg_dir=${etc_dir}/nagios/local",
    path    => "${etc_dir}/nagios/nagios.cfg",
    require => File["${etc_dir}/nagios/local"],
  }

  concat { "${etc_dir}/check_mk/main.mk":
    owner => $site,
    group => $site,
    mode  => '0644',
  }

  # # all_hosts
  concat::fragment { 'all_hosts-header':
    target  => "${etc_dir}/check_mk/main.mk",
    content => "all_hosts = [\n",
    order   => 10,
  }

  file { "${etc_dir}/check_mk/all_hosts_static":
    ensure  => file,
    content => template('check_mk/all_hosts_static.erb'),
  }

  # # local list of hosts is in /omd/sites/${site}/etc/check_mk/all_hosts_static and is appended
  concat::fragment { 'all-hosts-static':
    source => "${etc_dir}/check_mk/all_hosts_static",
    target => "${etc_dir}/check_mk/main.mk",
    order  => 18,
  }

  concat::fragment { 'all_hosts-footer':
    target  => "${etc_dir}/check_mk/main.mk",
    content => "]\n",
    order   => 19,
  }

  #TODO: Check if nodes are added automatically because we removed the exec
  Check_mk::Host <<| |>> {
    target => "${etc_dir}/check_mk/main.mk",
    notify => Exec['check_mk-reload'],
  }

  # # host_groups
  if $host_groups {
    file { "${etc_dir}/nagios/local/hostgroups":
      ensure => directory,
    }
    concat::fragment { 'host_groups-header':
      target  => "${etc_dir}/check_mk/main.mk",
      content => "host_groups = [\n",
      order   => 20,
    }
    concat::fragment { 'host_groups-footer':
      target  => "${etc_dir}/check_mk/main.mk",
      content => "]\n",
      order   => 29,
    }
    $groups = keys($host_groups)
    check_mk::hostgroup { $groups:
      dir        => "${etc_dir}/nagios/local/hostgroups",
      hostgroups => $host_groups,
      target     => "${etc_dir}/check_mk/main.mk",
    }
  }

  # # local config is in /omd/sites/${site}/etc/check_mk/main.mk.local and is appended
  file { "${etc_dir}/check_mk/main.mk.local":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => 'u=rw,go=r',
  }

  concat::fragment { 'check_mk-local-config':
    source => "${etc_dir}/check_mk/main.mk.local",
    target => "${etc_dir}/check_mk/main.mk",
    order  => 99,
  }

  exec { 'check_mk-reload':
    command     => "/bin/su -l -c '${bin_dir}/check_mk --reload' ${site}",
    refreshonly => true,
  }

  # In the original code 2 execs would be here, but is is not recommended
  # to do a reindex, see https://mathias-kettner.de/checkmk_inventory.html
  # This breaks large installs. The services class is subscribed to the
  # config class so new changes should be noticed automatically.
}
