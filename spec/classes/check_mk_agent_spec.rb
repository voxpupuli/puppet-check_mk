require 'spec_helper'

describe 'check_mk::agent' do
  on_supported_os.each do |os, os_facts|
    context "with default parameters set on #{os}" do
      let(:facts) { os_facts }

      it {
        is_expected.to compile
        is_expected.to contain_class('check_mk::agent')
        is_expected.to contain_class('check_mk::agent::install')
        is_expected.to contain_class('check_mk::agent::config').that_requires('Class[check_mk::agent::install]')
      }
    end
    context "with mrpe_checks on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          mrpe_checks: {
            check1: {
              command: 'command1'
            },
            check2: {
              command: 'command2'
            }
          }
        }
      end

      it {
        is_expected.to compile
        is_expected.to contain_class('check_mk::agent')
        is_expected.to contain_class('check_mk::agent::install')
        is_expected.to contain_class('check_mk::agent::config').that_requires('Class[check_mk::agent::install]')
      }
    end
  end
end
