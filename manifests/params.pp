# Class: check_mk::params
#
# @summary Sets the defaults for the init class.
# @api private
#
class check_mk::params {
  # common variables
  $checkmk_service = 'omd'
  $package = 'check-mk-raw-1.5.0p7-el7-38.x86_64.rpm'
  $filestore = undef
  $host_groups= undef
  $monitoring_site = 'monitoring'
  $workspace = '/root/check_mk'

  # OS specific variables
  case $facts['os']['family'] {
    'RedHat': {
      $httpd_service = 'httpd'
      if versioncmp($facts['os']['release']['major'],'8') >= 0 {
        $use_server_xinetd = false
      }
      else {
        $use_server_xinetd = true
      }
    }
    'Debian': {
      $httpd_service = 'apache2'
      $use_server_xinetd = true
    }
    default: {
      fail("OS family ${facts['os']['family']} is not supported!")
    }
  }
}
