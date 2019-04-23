require 'spec_helper'

describe 'check_mk::agent::config' do
  on_supported_os.each do |os, os_facts|
    context "with default parameters set on #{os}" do
      let(:facts) { os_facts }

      it {
        is_expected.to compile
      }
    end
    context "with default parameters set on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          encryption_secret: 'SECRET'
        }
      end

      it {
        is_expected.to compile
        case facts[:osfamily]
        when 'RedHat'
          is_expected.to contain_file('encryption_config').with(
            'ensure'  => 'file',
            'mode'    => '0600',
            'path'    => '/etc/check-mk-agent/encryption.cfg',
            'content' => %r{PASSPHRASE=SECRET\n}
          )
        when 'Debian'
          is_expected.to contain_file('encryption_config').with(
            'ensure'  => 'file',
            'mode'    => '0600',
            'path'    => '/etc/check_mk/encryption.cfg',
            'content' => %r{PASSPHRASE=SECRET\n}
          )
        end
      }
    end
  end
end
