require 'spec_helper'
describe 'check_mk::agent::mrpe', type: :define do
  let :title do
    'checkname'
  end
  context 'Unsupported OS' do
    let :facts do
      {
        operatingsystem: 'Solaris'
      }
    end

    context 'with mandatory command' do
      let :params do
        {command: 'command'}
      end

      it { is_expected.to compile.and_raise_error(%r{Creating mrpe\.cfg is unsupported for operatingsystem}) }
    end
  end
  context 'RedHat Linux' do
    let :facts do
      {
        operatingsystem: 'redhat'
      }
    end
    context 'with mandatory command' do
      let :params do
        {command: 'command'}
      end
      it { is_expected.to contain_check_mk__agent__mrpe('checkname') }
      it { is_expected.to contain_concat('/etc/check-mk-agent/mrpe.cfg').with_ensure('present') }
      it { is_expected.to contain_concat__fragment('checkname-mrpe-check').with({
                                                                                  target: '/etc/check-mk-agent/mrpe.cfg',
                                                                                  content: /^checkname command\n$/
                                                                                })
      }
    end
  end
end
