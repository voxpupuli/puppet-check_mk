require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  if fact_on(host, 'os.family') == 'RedHat'
    install_package(host, 'epel-release')
    install_package(host, 'nc')
  end
  install_package(host, 'nmap')
end
