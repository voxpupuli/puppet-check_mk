# Class: check_mk::agent::service
#
# @summary Manages the xinetd service
#
# @api private
#
class check_mk::agent::service (
  Boolean $use_xinetd = $check_mk::agent::use_xinetd,
  String $service_name = $check_mk::agent::service_name,
) {
  if $use_xinetd {
    ensure_packages(['xinetd'])
    Package['xinetd'] ~> Service['xinetd']

    service { "${service_name}.socket":
      ensure => 'stopped',
      enable => false,
      notify => Service['xinetd'],
    }

    if ! defined(Service['xinetd']) {
      service { 'xinetd':
        ensure     => 'running',
        enable     => true,
        hasrestart => true,
        restart    => 'kill -USR2 `pidof xinetd`',
      }
    }
  } else {
    if ! defined(Service['xinetd']) {
      # We need an xinetd service in the catalog that we can notify to reload,
      # but we otherwise don't want to manage the state of xinetd when using
      # systemd sockets for check-mk-agent
      #
      # Note, if the service isn't running, (eg. because it's not even installed)
      # puppet will skip trying to do a restart.
      # This means we don't have to force the doomed `kill` command to return 0.
      service { 'xinetd':
        hasrestart => true,
        restart    => 'kill -USR2 `pidof xinetd` && sleep 1',
      }
    }
    service { "${service_name}.socket":
      ensure  => 'running',
      enable  => true,
      require => Service['xinetd'],
    }
  }
}
