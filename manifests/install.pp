# Class: check_mk::install
#
# @summary Installs check_mk using .deb or .rpm file.
# @api private
#

class check_mk::install (
  String $site,
  Stdlib::Absolutepath $workspace,
  Optional[String] $filestore = undef,
  Optional[Pattern[/^(check-mk-(\w*))(-|_)(\d*\.\d*\.\d*p\d*).+\.(\w+)$/]] $package = undef,
) {
  if $filestore {
    if ! defined(File[$workspace]) {
      file { $workspace:
        ensure => directory,
      }
    }
    file { "${workspace}/${package}":
      ensure  => file,
      source  => "${filestore}/${package}",
      require => File[$workspace],
    }

    # check-mk-raw-1.5.0p7_0.stretch_amd64.deb
    if $package =~ /^(check-mk-\w*(-|_)\d*\.\d*\.\d*p\d*).+\.(\w+)$/ {
      $type = $3
      $package_name = $1

      if $type == 'deb' {
        package { 'gdebi':
          ensure => present,
        }

        exec { 'install-check-mk':
          command => "/usr/bin/gdebi --non-interactive ${workspace}/${package}",
          unless  => "/usr/bin/dpkg-query -W --showformat '\${Status} \${Package}\\n' | grep ${package_name} | grep -q 'install ok installed'", # lint:ignore:140chars
          require => Package['gdebi'],
          before  => Exec['omd-create-site'],
        }
      } elsif $type == 'rpm' {
        package { $package_name:
          ensure   => installed,
          provider => 'yum',
          source   => "${workspace}/${package}",
          require  => File["${workspace}/${package}"],
          before   => Exec['omd-create-site'],
        }
      } else {
        fail('Only support RPM or DEB files.')
      }
    } else {
      fail('Package does not match format like check-mk-raw-1.5.0p7_0.stretch_amd64.deb')
    }
  }
  else {
    $package_name = $package
    package { $package_name:
      ensure => installed,
      before => Exec['omd-create-site'],
    }
  }
  $etc_dir = "/omd/sites/${site}/etc"
  exec { 'omd-create-site':
    command => "/usr/bin/omd create ${site}",
    creates => $etc_dir,
  }
}
