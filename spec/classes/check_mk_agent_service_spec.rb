require 'spec_helper'
describe 'check_mk::agent::service', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to contain_class('check_mk::agent::service') }
      it {
        is_expected.to contain_service('xinetd').with(ensure: 'running',
                                                      enable: true)
      }

      if facts[:osfamily] == 'Debian' && facts[:operatingsystemmajrelease] == '7'
        it { is_expected.to contain_class('check_mk::agent::service') }
        it {
          is_expected.to contain_service('xinetd').with(ensure: 'running',
                                                        enable: true,
                                                        hasstatus: false)
        }
      end
    end
  end
end
