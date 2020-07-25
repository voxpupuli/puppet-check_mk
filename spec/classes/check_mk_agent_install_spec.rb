require 'spec_helper'

describe 'check_mk::agent::install' do
  on_supported_os.each do |os, os_facts|
    context "with default parameters set on #{os}" do
      let(:facts) { os_facts }

      it {
        is_expected.to compile
        is_expected.to contain_package('check_mk-agent').with(
          'ensure' => 'present',
          'name'   => 'check-mk-agent'
        )
        is_expected.to contain_class('check_mk::agent::install')
      }
    end

    context "with custom package on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          package: 'custom-package'
        }
      end

      it {
        is_expected.to compile
        is_expected.to contain_class('check_mk::agent::install')
        is_expected.to contain_package('check_mk-agent').with(
          'name' => 'custom-package'
        )
      }
    end

    context "with custom package_ensure on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          package_ensure: '1.2.8p27-1'
        }
      end

      it { is_expected.to contain_package('check_mk-agent').with_ensure('1.2.8p27-1') }
    end

    context "with filestore on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          filestore: '/filestore',
          package: 'check-mk-agent_1.5.0p7-1_all.deb',
          workspace: '/workspace'
        }
      end

      it {
        is_expected.to compile
        is_expected.to contain_class('check_mk::agent::install')
        is_expected.to contain_file('/workspace/check-mk-agent_1.5.0p7-1_all.deb').with(
          'ensure' => 'file',
          'source' => '/filestore/check-mk-agent_1.5.0p7-1_all.deb'
        )
        is_expected.to contain_package('check_mk-agent').with(
          'ensure'   => 'present',
          'name'     => 'check-mk-agent',
          'provider' => 'dpkg',
          'source'   => '/workspace/check-mk-agent_1.5.0p7-1_all.deb'
        ).that_requires('File[/workspace/check-mk-agent_1.5.0p7-1_all.deb]')
      }
    end
  end
end
