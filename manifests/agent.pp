# Class: check_mk::agent
#
# @summary Configures and install the check_mk agent.
# @param filestore The location where the installation file can be found
# @param host_tags Tags that needs to be added to the node if resource export is enabled.
# @param workspace Temp folder where the installation file will be placed.
# @param package The package name to be installed.
# @param mrpe_checks A hash containing mrpe command that will be passed to the mrpe defined type.
# @param encryption_secret A secret that will be used to encrypt communication with the master.
# @param config_dir The config directory for the agent.
#
class check_mk::agent (
  Optional[String] $filestore = undef,
  Optional[Array] $host_tags = undef,
  Stdlib::Absolutepath $workspace = '/root/check_mk',
  Optional[String] $package = 'check-mk-agent',
  Hash $mrpe_checks = {},
  Optional[String] $encryption_secret = undef,
  Stdlib::Absolutepath $config_dir = $check_mk::agent::params::config_dir,
) inherits check_mk::agent::params {
  include check_mk::agent::install
  include check_mk::agent::config
  Class['check_mk::agent::install'] -> Class['check_mk::agent::config']

  @@check_mk::host { $::fqdn:
    host_tags => $host_tags,
  }

  create_resources('check_mk::agent::mrpe', $mrpe_checks)
}
