require 'spec_helper'

describe 'check_mk::agent::mrpe' do
  let(:pre_condition) do
    "class { 'check_mk::agent': }"
  end
  let(:title) { 'check1' }
  let(:params) do
    {
      command: 'command1'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it {
        is_expected.to compile
        case facts[:osfamily]
        when 'RedHat'
          is_expected.to contain_concat('/etc/check-mk-agent/mrpe.cfg').with(
            'ensure' => 'present'
          )

          is_expected.to contain_concat__fragment('check1-mrpe-check').with(
            'target'  => '/etc/check-mk-agent/mrpe.cfg',
            'content' => %r{check1 command1\n}
          )
        when 'Debian'
          is_expected.to contain_concat('/etc/check_mk/mrpe.cfg').with(
            'ensure' => 'present'
          )

          is_expected.to contain_concat__fragment('check1-mrpe-check').with(
            'target'  => '/etc/check_mk/mrpe.cfg',
            'content' => %r{check1 command1\n}
          )
        end
      }
    end
  end
end
