# Class: check_mk::agent::config
#
# @summary Configures the check_mk client.
# @api private
#
class check_mk::agent::config (
  Optional[String] $encryption_secret = $check_mk::agent::encryption_secret,
  Stdlib::Absolutepath $config_dir = $check_mk::agent::config_dir,
) inherits check_mk::agent {
  if $encryption_secret {
    file {'encryption_config':
      ensure  => file,
      mode    => '0600',
      path    => "${config_dir}/encryption.cfg",
      content => template('check_mk/agent/encryption.cfg.erb'),
    }
  }
}
