require 'spec_helper'
describe 'check_mk::service' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:pre_condition) { 'include check_mk' }

      service_name = case facts[:osfamily]
                     when 'Debian'
                       'apache2'
                     else
                       'httpd'
                     end

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('check_mk::service') }
        it {
          is_expected.to contain_service(service_name).with(ensure: 'running',
                                                            enable: 'true')
        }
        it {
          is_expected.to contain_service('omd').with(ensure: 'running',
                                                     enable: 'true')
        }
      end
    end
  end
end
