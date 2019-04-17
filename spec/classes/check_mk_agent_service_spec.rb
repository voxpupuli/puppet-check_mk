require 'spec_helper'
describe 'check_mk::agent::service', type: :class do
  context 'all' do
    it { is_expected.to contain_class('check_mk::agent::service') }
    it {
      is_expected.to contain_service('xinetd').with(ensure: 'running',
                                                    enable: true)
    }
  end

  context 'Debian 7' do
    let :facts do
      {
        operatingsystem: 'Debian',
        operatingsystemmajrelease: '7'
      }
    end

    it { is_expected.to contain_class('check_mk::agent::service') }
    it {
      is_expected.to contain_service('xinetd').with(ensure: 'running',
                                                    enable: true,
                                                    hasstatus: false)
    }
  end
end
