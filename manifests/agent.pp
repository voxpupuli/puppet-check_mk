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
# @param use_xinetd Configure the service using the older xinetd approach.  Defaults to true on systems missing systemd, and false otherwise.
# @param check_mk_xinetd_path The path to the xinetd.d config file for check_mk
# @param ip_whitelist The list of IP addresses that are allowed to retrieve check_mk data. (Note that localhost is always allowed to connect.) By default any IP can connect.
# @param user The user that the agent runs as.
# @param group The group that the agent runs as.
# @param port The port the check_mk agent listens on.
# @param server_dir The directory in which the check_mk_agent executable is located.
# @param use_cache Whether or not to cache the results - useful with redundant monitoring server setups.
class check_mk::agent (
  Optional[String] $filestore = undef,
  Optional[Array] $host_tags = undef,
  Stdlib::Absolutepath $workspace = '/root/check_mk',
  Optional[String] $package = 'check-mk-agent',
  Hash $mrpe_checks = {},
  Optional[String] $encryption_secret = undef,
  Boolean $use_xinetd = !fact('systemd'),
  Stdlib::Absolutepath $check_mk_xinetd_path = '/etc/xinetd.d/check_mk',
  Array[Stdlib::IP::Address] $ip_whitelist = [],
  Stdlib::Absolutepath $server_dir = '/usr/bin',
  Boolean $use_cache = false,
  Stdlib::Port $port = 6556,
  String[1] $user = 'root',
  String[1] $group = $user,
  Stdlib::Absolutepath $config_dir = $check_mk::agent::params::config_dir,
) inherits check_mk::agent::params {

  include check_mk::agent::install
  include check_mk::agent::config
  include check_mk::agent::service
  Class['check_mk::agent::install']
  -> Class['check_mk::agent::config']
  ~> Class['check_mk::agent::service']

  @@check_mk::host { $facts['fqdn']:
    host_tags => $host_tags,
  }

  create_resources('check_mk::agent::mrpe', $mrpe_checks)
}
