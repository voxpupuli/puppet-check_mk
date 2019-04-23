require 'spec_helper'

describe 'check_mk::install' do
  on_supported_os.each do |os, os_facts|
    context "with necessary parameters set on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          filestore: '/filestore/',
          package: 'check-mk-raw-1.5.0p7_0.stretch_amd64.deb',
          site: 'site',
          workspace: '/workspace'
        }
      end

      it {
        is_expected.to compile

        is_expected.to contain_class('check_mk::install')

        is_expected.to contain_exec('omd-create-site').with(
          'command' => '/usr/bin/omd create site',
          'creates' => '/omd/sites/site/etc'
        ).that_requires('Exec[install-check-mk]')

        is_expected.to contain_package('gdebi').with(
          'ensure' => 'present'
        )

        is_expected.to contain_exec('install-check-mk').with(
          'command' => '/usr/bin/gdebi --non-interactive /workspace/check-mk-raw-1.5.0p7_0.stretch_amd64.deb',
          'unless'  => '/usr/bin/dpkg-query -W --showformat \'${Status} ${Package}\n\' | grep check-mk-raw-1.5.0p7 | grep -q \'install ok installed\''
        ).that_requires('Package[gdebi]')
      }
    end

    context "with rpm file set on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          filestore: '/filestore/',
          package: 'check-mk-raw-1.5.0p7-el7-38.x86_64.rpm',
          site: 'site',
          workspace: '/workspace'
        }
      end

      it {
        is_expected.to compile

        is_expected.to contain_exec('omd-create-site').with(
          'command' => '/usr/bin/omd create site',
          'creates' => '/omd/sites/site/etc'
        ).that_requires('Package[check-mk-raw-1.5.0p7]')

        is_expected.to contain_package('check-mk-raw-1.5.0p7').with(
          'ensure'   => 'installed',
          'provider' => 'yum',
          'source'   => '/workspace/check-mk-raw-1.5.0p7-el7-38.x86_64.rpm'
        ).that_requires('File[/workspace/check-mk-raw-1.5.0p7-el7-38.x86_64.rpm]')
      }
    end
  end
end
