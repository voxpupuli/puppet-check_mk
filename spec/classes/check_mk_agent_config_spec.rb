# frozen_string_literal: true

require 'spec_helper'

describe 'check_mk::agent::config' do
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

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/check_mk/encryption.cfg').with_ensure('absent') }
      end

      context 'with encryption_secret parameter set' do
        let(:params) do
          {
            encryption_secret: 'SECRET'
          }
        end

        it {
          expect(subject).to contain_file('/etc/check_mk/encryption.cfg').with(
            'ensure' => 'file',
            'mode' => '0600'
          )
          content = catalogue.resource('file', '/etc/check_mk/encryption.cfg').parameters[:content]
          expect(content).to include("PASSPHRASE=SECRET\n")
        }
      end

      describe 'server_dir' do
        it { is_expected.to contain_systemd__dropin_file('check_mk unit overrides').with_content(%r{ExecStart=/usr/bin/check_mk_agent}) }

        context 'when set' do
          let(:params) do
            {
              server_dir: '/server_dir'
            }
          end

          it { is_expected.to contain_systemd__dropin_file('check_mk unit overrides').with_content(%r{ExecStart=/server_dir/check_mk_agent}) }
        end
      end

      describe 'port' do
        it { is_expected.to contain_systemd__dropin_file('check_mk socket overrides').with_content(%r{ListenStream=6556}) }

        context 'when set' do
          let(:params) do
            {
              port: 6666
            }
          end

          it { is_expected.to contain_systemd__dropin_file('check_mk socket overrides').with_content(%r{ListenStream=6666}) }
        end
      end

      describe 'user' do
        it { is_expected.to contain_systemd__dropin_file('check_mk unit overrides').with_content(%r{User=root}) }

        context 'when set' do
          let(:params) do
            {
              user: 'foo'
            }
          end

          it { is_expected.to contain_systemd__dropin_file('check_mk unit overrides').with_content(%r{User=foo}) }
        end
      end

      describe 'group' do
        it { is_expected.to contain_systemd__dropin_file('check_mk unit overrides').with_content(%r{Group=root}) }

        context 'when set' do
          let(:params) do
            {
              group: 'foo'
            }
          end

          it { is_expected.to contain_systemd__dropin_file('check_mk unit overrides').with_content(%r{Group=foo}) }
        end
      end

      describe 'use_cache' do
        context 'when true' do
          let(:params) do
            {
              use_cache: true
            }
          end

          it { is_expected.to contain_systemd__dropin_file('check_mk unit overrides').with_content(%r{ExecStart=/usr/bin/check_mk_caching_agent}) }
        end
      end

      describe 'ip_whitelist' do
        context 'by default' do
          it { is_expected.not_to contain_systemd__dropin_file('check_mk socket overrides').with_content(%r{IPAddressAllow}) }
        end

        context 'when set' do
          let(:params) do
            {
              ip_whitelist: ['1.1.1.1', '2.2.2.2']
            }
          end

          if facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemmajrelease] == '18.04'
            it { is_expected.to contain_systemd__dropin_file('check_mk socket overrides').with_content(%r{IPAddressAllow=127\.0\.0\.1 1\.1\.1\.1 2\.2\.2\.2}) }
          else
            it { is_expected.to compile.and_raise_error(%r{ip_whitelist is only supported when using systemd version 235 and later}) }
          end
        end
      end

      context 'with non-standard unit name' do
        let(:params) do
          {
            service_name: 'custom-check-mk-agent'
          }
        end

        it do
          expect(subject).to contain_systemd__dropin_file('check_mk socket overrides').with(
            unit: 'custom-check-mk-agent.socket'
          )
        end

        it do
          expect(subject).to contain_systemd__dropin_file('check_mk unit overrides').with(
            unit: 'custom-check-mk-agent@.service'
          )
        end
      end
    end
  end
end
