# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  if fact_on(host, 'os.family') == 'RedHat'
    install_package(host, 'epel-release')
    install_package(host, 'nc')
    install_package(host, 'nmap-ncat')
    if fact_on(host, 'os.release.major') == '8'
      install_package(host, 'dnf-plugin-config-manager')
      on(host, 'dnf config-manager --set-enabled powertools')
    end
  else
    install_package(host, 'ncat')
  end
end
