# Class: check_mk::agent::install
#
# @summary Installs the check_mk client.
# @api private
#
class check_mk::agent::install (
  $filestore      = $check_mk::agent::filestore,
  $workspace      = $check_mk::agent::workspace,
  $package        = $check_mk::agent::package,
  $package_ensure = $check_mk::agent::package_ensure,
) inherits check_mk::agent {
  if $filestore {
    if ! defined(File[$workspace]) {
      file { $workspace:
        ensure => directory,
      }
    }

    # check-mk-agent_1.5.0p7-1_all.deb
    if $package =~ /^(check-mk-(\w*))(-|_)(\d*\.\d*\.\d*p\d*).+\.(\w+)$/ {
      case $5 {
        'deb':     {
          $type = 'dpkg'
        }
        default: {
          $type = $5
        }
      }
      $package_name = $1

      file { "${workspace}/${package}":
        ensure => file,
        source => "${filestore}/${package}",
      }

      package { 'check_mk-agent':
        ensure   => present,
        name     => $package_name,
        provider => $type,
        source   => "${workspace}/${package}",
        require  => File["${workspace}/${package}"],
      }
    } else {
      fail('Package does not match format like check-mk-agent_1.5.0p7-1_all.deb')
    }
  } else {
    package { 'check_mk-agent':
      ensure => $package_ensure,
      name   => $package,
    }
  }
}
