# Type: check_mk::agent::mrpe
#
# @summary Adds a command to the MRPE config.
# @param command The command to be added to the MRPE config.
# @param config_dir The path to the directory where the mrpe.cfg is.
#
define check_mk::agent::mrpe (
  String $command,
  Stdlib::Absolutepath $config_dir = $check_mk::agent::config_dir,
) {
  $mrpe_config_file = "${config_dir}/mrpe.cfg"

  if ! defined(Concat[$mrpe_config_file]) {
    concat { $mrpe_config_file:
      ensure => 'present',
    }
  }

  concat::fragment { "${name}-mrpe-check":
    target  => $mrpe_config_file,
    content => "${name} ${command}\n",
  }
}
