require 'spec_helper'

describe 'check_mk::agent::service' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'when using xinetd' do
        let(:params) { { use_xinetd: true } }

        it { is_expected.to contain_package('xinetd') }
        it { is_expected.to contain_service('check_mk.socket').with_ensure('stopped').with_enable(false) }
        it {
          is_expected.to contain_service('xinetd').with(
            'ensure'     => 'running',
            'enable'     => true,
            'hasrestart' => true,
            'restart'    => 'kill -USR2 `pidof xinetd`'
          ).that_subscribes_to(['Package[xinetd]', 'Service[check_mk.socket]'])
        }
      end
      context 'when using systemd' do
        let(:params) { { use_xinetd: false } }

        it { is_expected.not_to contain_package('xinetd') }
        it {
          is_expected.to contain_service('xinetd').with(
            'hasrestart' => true,
            'restart'    => 'kill -USR2 `pidof xinetd` && sleep 1'
          )
        }
        it {
          is_expected.to contain_service('check_mk.socket').with(
            'ensure' => 'running',
            'enable' => true
          ).that_requires('Service[xinetd]')
        }
      end
    end
  end
end
