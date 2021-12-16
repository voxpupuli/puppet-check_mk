# frozen_string_literal: true

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

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      systemd_facts = case facts[:operatingsystem]
                      when 'RedHat', 'CentOS', 'OracleLinux'
                        case facts[:operatingsystemmajrelease]
                        when '7'
                          {
                            'systemd' => true,
                            'systemd_version' => '219'
                          }
                        end
                      when 'Debian'
                        case facts[:operatingsystemmajrelease]
                        when '9'
                          {
                            'systemd' => true,
                            'systemd_version' => '232'
                          }
                        end
                      when 'Ubuntu'
                        case facts[:operatingsystemmajrelease]
                        when '18.04'
                          {
                            'systemd' => true,
                            'systemd_version' => '237'
                          }
                        when '18.10'
                          {
                            'systemd' => true,
                            'systemd_version' => '239'
                          }
                        end
                      end
      raise("systemd facts missing for #{os}") if systemd_facts.nil?

      let(:facts) { facts.merge(systemd_facts) }

      it { is_expected.to compile }
      it { is_expected.to contain_concat('/etc/check_mk/mrpe.cfg').with_ensure('present') }

      it {
        expect(subject).to contain_concat__fragment('check1-mrpe-check').with(
          'target' => '/etc/check_mk/mrpe.cfg',
          'content' => %r{check1 command1\n}
        )
      }
    end
  end
end
