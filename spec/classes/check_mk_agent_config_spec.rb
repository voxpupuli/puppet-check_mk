require 'spec_helper'

describe 'check_mk::agent::config' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      systemd_facts = case facts[:operatingsystem]
                      when 'RedHat', 'CentOS', 'OracleLinux'
                        case facts[:operatingsystemmajrelease]
                        when '5'
                          {
                            'systemd' => false
                          }
                        when '6'
                          {
                            'systemd' => false
                          }
                        when '7'
                          {
                            'systemd'         => true,
                            'systemd_version' => '219'
                          }
                        end
                      when 'Debian'
                        case facts[:operatingsystemmajrelease]
                        when '7'
                          {
                            'systemd'         => false, # systemd was only a tech preview and not enabled by default
                          }
                        when '8'
                          {
                            'systemd'         => true,
                            'systemd_version' => '215'
                          }
                        when '9'
                          {
                            'systemd'         => true,
                            'systemd_version' => '232'
                          }
                        end
                      when 'Ubuntu'
                        case facts[:operatingsystemmajrelease]
                        when '16.04'
                          {
                            'systemd'         => true,
                            'systemd_version' => '229'
                          }
                        when '18.04'
                          {
                            'systemd'         => true,
                            'systemd_version' => '237'
                          }
                        when '18.10'
                          {
                            'systemd'         => true,
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
          is_expected.to contain_file('/etc/check_mk/encryption.cfg').with(
            'ensure'  => 'file',
            'mode'    => '0600',
            'content' => %r{PASSPHRASE=SECRET\n}
          )
        }
      end

      describe 'use_xinetd' do
        context 'by default' do
          it 'sets use_xinetd based on OS' do
            if facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease] =~ %r{^5|6}
              is_expected.to contain_class('check_mk::agent::config').with_use_xinetd(true)
            elsif facts[:osfamily] == 'Debian' && facts[:operatingsystemmajrelease] == '7'
              is_expected.to contain_class('check_mk::agent::config').with_use_xinetd(true)
            else
              is_expected.to contain_class('check_mk::agent::config').with_use_xinetd(false)
            end
          end
        end
        context 'when using xinetd' do
          let(:params) do
            {
              use_xinetd: true
            }
          end

          it { is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{set service/disable no}) }
          describe 'server_dir' do
            context 'by default' do
              it { is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{set service/server /usr/bin/check_mk_agent}) }
            end
            context 'when set' do
              let(:params) do
                {
                  use_xinetd: true,
                  server_dir: '/path/to/bin'
                }
              end

              it { is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{set service/server /path/to/bin/check_mk_agent}) }
            end
          end
          describe 'use_cache' do
            context 'when false' do
              it { is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{set service/server /usr/bin/check_mk_agent}) }
            end
            context 'when true' do
              let(:params) do
                {
                  use_xinetd: true,
                  use_cache: true
                }
              end

              it { is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{set service/server /usr/bin/check_mk_caching_agent}) }
            end
          end
          describe 'user' do
            context 'by default' do
              it { is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{set service/user root}) }
            end
            context 'when set' do
              let(:params) do
                {
                  use_xinetd: true,
                  user: 'foo'
                }
              end

              it { is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{set service/user foo}) }
            end
          end
          describe 'group' do
            context 'by default' do
              it { is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{set service/group root}) }
            end
            context 'when set' do
              let(:params) do
                {
                  use_xinetd: true,
                  group: 'foo'
                }
              end

              it { is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{set service/group foo}) }
            end
          end
          describe 'port' do
            context 'by default' do
              it { is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{set service/port 6556}) }
            end
            context 'when set' do
              let(:params) do
                {
                  use_xinetd: true,
                  port: 6666
                }
              end

              it { is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{set service/port 6666}) }
            end
          end
          describe 'check_mk_xinetd_path' do
            let(:params) do
              {
                use_xinetd: true,
                check_mk_xinetd_path: '/path/to/xinet/check_mk/config'
              }
            end

            it { is_expected.to contain_augeas('check_mk xinetd config').with_incl('/path/to/xinet/check_mk/config') }
          end
          describe 'ip_whitelist' do
            context 'by default' do
              it 'removes only_from setting from xinetd config file' do
                is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{rm service/only_from})
              end
              it 'doesn\'t set only_from setting' do
                is_expected.not_to contain_augeas('check_mk xinetd config').with_changes(%r{set service/only_from})
              end
            end
            context 'when set' do
              let(:params) do
                {
                  use_xinetd: true,
                  ip_whitelist: ['1.1.1.1', '2.2.2.2']
                }
              end

              it 'removes only_from setting from xinetd config file' do
                is_expected.to contain_augeas('check_mk xinetd config').with_changes(%r{rm service/only_from})
              end
              it 'adds 127.0.0.1 and IPs given to only_from' do
                is_expected.to contain_augeas('check_mk xinetd config').
                  with_changes(%r{set service/only_from/value\[last\(\)\+1\] 127\.0\.0\.1}).
                  with_changes(%r{set service/only_from/value\[last\(\)\+1\] 1\.1\.1\.1}).
                  with_changes(%r{set service/only_from/value\[last\(\)\+1\] 2\.2\.2\.2})
              end
            end
          end
        end
        context 'when using systemd' do
          let(:params) do
            {
              use_xinetd: false
            }
          end

          if systemd_facts['systemd']
            it { is_expected.to contain_augeas('Disable check_mk xinetd').with_changes(%r{set service/disable yes}) }
            describe 'server_dir' do
              it { is_expected.to contain_systemd__dropin_file('check_mk unit overrides').with_content(%r{ExecStart=/usr/bin/check_mk_agent}) }
              context 'when set' do
                let(:params) do
                  {
                    use_xinetd: false,
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
                    use_xinetd: false,
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
                    use_xinetd: false,
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
                    use_xinetd: false,
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
                    use_xinetd: false,
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
                    use_xinetd: false,
                    ip_whitelist: ['1.1.1.1', '2.2.2.2']
                  }
                end

                if facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemmajrelease] == '18.04'
                  it { is_expected.to contain_systemd__dropin_file('check_mk socket overrides').with_content(%r{IPAddressAllow=127\.0\.0\.1 1\.1\.1\.1 2\.2\.2\.2}) }
                else
                  it { is_expected.to compile.and_raise_error(%r{ip_whitelist is only supported when using xinetd or systemd version 235 and later}) }
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
                is_expected.to contain_systemd__dropin_file('check_mk socket overrides').with(
                  unit: 'custom-check-mk-agent.socket'
                )
              end

              it do
                is_expected.to contain_systemd__dropin_file('check_mk unit overrides').with(
                  unit: 'custom-check-mk-agent@.service'
                )
              end
            end
          else
            it { is_expected.to compile.and_raise_error(%r{Your system doesn't appear to support systemd, you must use xinetd instead}) }
          end
        end
      end
    end
  end
end
