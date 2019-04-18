require 'spec_helper'
describe 'check_mk' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('check_mk') }
        it {
          is_expected.to contain_class('check_mk::install').with(filestore: nil,
                                                                 package: 'check-mk-raw-1.5.0p7-el7-38.x86_64.rpm',
                                                                 site: 'monitoring',
                                                                 workspace: '/root/check_mk').that_comes_before('Class[check_mk::config]')
        }
        it {
          is_expected.to contain_class('check_mk::config').with(host_groups: nil,
                                                                site: 'monitoring').that_comes_before('Class[check_mk::service]')
        }
        it { is_expected.to contain_class('check_mk::service') }
      end
    end
  end
end
