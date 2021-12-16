# Class: check_mk::agent::service
#
# @summary Manages the xinetd service
#
# @api private
#
class check_mk::agent::service (
  String $service_name = $check_mk::agent::service_name,
) {
  service { "${service_name}.socket":
    ensure => 'running',
    enable => true,
  }
}
