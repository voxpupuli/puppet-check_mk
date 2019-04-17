require 'spec_helper'
describe 'check_mk::agent::service', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { should contain_class('check_mk::agent::service') }
      it { should contain_service('xinetd').with({
        :ensure => 'running',
        :enable => true,
      })
      }

      if facts[:osfamily] == 'Debian' and facts[:operatingsystemmajrelease] == '7'
        it { should contain_class('check_mk::agent::service') }
        it { should contain_service('xinetd').with({
          :ensure    => 'running',
          :enable    => true,
          :hasstatus => false,
        })
        }
      end
    end
  end
end
