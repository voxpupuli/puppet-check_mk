require 'spec_helper'
describe 'check_mk::agent::install', type: :class do
  context 'RedHat Linux' do
    let :facts do
      {
        osfamily: 'Redhat'
      }
    end

    context 'with default parameters' do
      it {
        is_expected.to contain_class('check_mk::agent::install').with(
          version: nil,
          filestore: nil,
          workspace: '/root/check_mk',
          package: nil
        )
      }
      it { is_expected.to contain_package('xinetd') }
      it { is_expected.to contain_package('check_mk-agent').with_name('check-mk-agent') }
    end

    context 'with custom package' do
      let :params do
        {
          package: 'custom-package'
        }
      end

      it { is_expected.to contain_class('check_mk::agent::install') }
      it { is_expected.to contain_package('xinetd') }
      it { is_expected.to contain_package('check_mk-agent').with_name('custom-package') }
    end

    context 'with filestore' do
      context 'without version' do
        let :params do
          {
            filestore: '/filestore'
          }
        end

        it 'fails' do
          expect { catalogue }.to raise_error(Puppet::Error, %r{version must be specified})
        end
      end
      context 'with custom parameters' do
        let :params do
          {
            version: '1.2.3',
            filestore: '/filestore',
            workspace: '/workspace'
          }
        end

        it { is_expected.to contain_class('check_mk::agent::install') }
        it { is_expected.to contain_package('xinetd') }
        it { is_expected.to contain_file('/workspace').with_ensure('directory') }
        it {
          is_expected.to contain_File('/workspace/check_mk-agent-1.2.3.noarch.rpm').with(
            ensure: 'present',
            source: '/filestore/check_mk-agent-1.2.3.noarch.rpm',
            require: 'Package[xinetd]'
          ).that_comes_before('Package[check_mk-agent]')
        }
        it {
          is_expected.to contain_package('check_mk-agent').with(
            provider: 'rpm',
            source: '/workspace/check_mk-agent-1.2.3.noarch.rpm'
          )
        }
      end
    end
  end

  context 'Debian Linux' do
    let :facts do
      {
        osfamily: 'Debian'
      }
    end

    context 'with default parameters' do
      it { is_expected.to contain_class('check_mk::agent::install') }
      it { is_expected.to contain_package('xinetd') }
      it { is_expected.to contain_package('check_mk-agent').with_name('check-mk-agent') }
    end

    context 'with custom package' do
      let :params do
        {
          package: 'custom-package'
        }
      end

      it { is_expected.to contain_class('check_mk::agent::install') }
      it { is_expected.to contain_package('xinetd') }
      it { is_expected.to contain_package('check_mk-agent').with_name('custom-package') }
    end
  end

  context 'Unknown OS' do
    context 'with default parameters' do
      it { is_expected.to contain_class('check_mk::agent::install') }
      it { is_expected.to contain_package('xinetd') }
      it { is_expected.to contain_package('check_mk-agent').with_name('check_mk-agent') }
    end
    context 'with custom package' do
      let :params do
        {
          package: 'custom-package'
        }
      end

      it { is_expected.to contain_class('check_mk::agent::install') }
      it { is_expected.to contain_package('xinetd') }
      it { is_expected.to contain_package('check_mk-agent').with_name('custom-package') }
    end
  end
end
