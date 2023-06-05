class check_mk::service (
  $checkmk_service,
  $httpd_service,
  Boolean $enable_xinetd = $check_mk::params::use_server_xinetd,
) {
  if ! defined(Service[$httpd_service]) {
    service { $httpd_service:
      ensure => 'running',
      enable => true,
    }
  }
  if $enable_xinetd {
    if ! defined(Service[xinetd]) {
      service { 'xinetd':
        ensure => 'running',
        enable => true,
      }
    }
  }
  service { $checkmk_service:
    ensure => 'running',
    enable => true,
  }
}
