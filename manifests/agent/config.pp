# Class: check_mk::agent::config
#
# @summary Configures the check_mk client.
# @api private
#
class check_mk::agent::config (
  Optional[String]           $encryption_secret    = $check_mk::agent::encryption_secret,
  Boolean                    $use_xinetd           = $check_mk::agent::use_xinetd,
  Stdlib::Absolutepath       $check_mk_xinetd_path = $check_mk::agent::check_mk_xinetd_path,
  Array[Stdlib::IP::Address] $ip_whitelist         = $check_mk::agent::ip_whitelist,
  Stdlib::Absolutepath       $server_dir           = $check_mk::agent::server_dir,
  Boolean                    $use_cache            = $check_mk::agent::use_cache,
  Stdlib::Port               $port                 = $check_mk::agent::port,
  String[1]                  $user                 = $check_mk::agent::user,
  String[1]                  $group                = $check_mk::agent::group,
  Stdlib::Absolutepath       $config_dir           = $check_mk::agent::config_dir,
  String[1]                  $service_name         = $check_mk::agent::service_name,
) inherits check_mk::agent {
  if $use_xinetd == false and fact('systemd') == false {
    fail('Your system doesn\'t appear to support systemd, you must use xinetd instead')
  }

  if $use_xinetd == false and versioncmp(fact('systemd_version'),'235') < 0 {
    unless $ip_whitelist.empty { fail('ip_whitelist is only supported when using xinetd or systemd version 235 and later') }
  }

  if $encryption_secret {
    file { "${config_dir}/encryption.cfg":
      ensure  => file,
      mode    => '0600',
      content => Sensitive(epp(
          'check_mk/agent/encryption.cfg.epp',
          {
            'encryption_secret' => $encryption_secret,
          },
      )),
    }
  } else {
    file { "${config_dir}/encryption.cfg":
      ensure => absent,
    }
  }

  if $use_cache {
    $server = "${server_dir}/check_mk_caching_agent"
  } else {
    $server = "${server_dir}/check_mk_agent"
  }

  if $ip_whitelist.empty() {
    $only_from = []
  } else {
    $only_from = ['127.0.0.1'] + $ip_whitelist
  }

  if $use_xinetd {
    $only_from_changes = ['rm service/only_from'] + $only_from.map |$ip| {
      "set service/only_from/value[last()+1] ${ip}"
    }

    $server_changes  = ["set service/server ${server}"]
    $port_changes    = ["set service/port ${port}"]
    $user_changes    = ["set service/user ${user}", "set service/group ${group}"]
    $disable_changes = ['set service/disable no']

    # LC_ALL environment variable must be unset to prevent a bash warning ending up in the xinetd stream
    # output and breaking the $encryption_secret feature.
    $env_changes     = ['rm service/env', 'set service/env/value[last()+1] "LC_ALL="']

    augeas { 'check_mk xinetd config':
      incl    => $check_mk_xinetd_path,
      lens    => 'xinetd.lns',
      changes => $only_from_changes + $server_changes + $port_changes + $user_changes + $disable_changes + $env_changes,
    }
  } else {
    augeas { 'Disable check_mk xinetd':
      incl    => $check_mk_xinetd_path,
      lens    => 'xinetd.lns',
      changes => ['set service/disable yes'],
    }

    $ip_address_allow = versioncmp(fact('systemd_version'),'235') ? {
      -1      => undef, # Don't set the parameter if the version of systemd doesn't support it
      default => $only_from,
    }

    systemd::dropin_file { 'check_mk socket overrides':
      filename => 'puppet.conf',
      unit     => "${service_name}.socket",
      content  => epp(
        'check_mk/agent/check_mk.socket-drop-in.epp',
        {
          'port'             => $port,
          'ip_address_allow' => $ip_address_allow,
        },
      ),
    }
    systemd::dropin_file { 'check_mk unit overrides':
      filename => 'puppet.conf',
      unit     => "${service_name}@.service",
      content  => epp(
        'check_mk/agent/check_mk.service-drop-in.epp',
        {
          'server' => $server,
          'user'   => $user,
          'group'  => $group,
        },
      ),
    }
  }
}
