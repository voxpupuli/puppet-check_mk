# frozen_string_literal: true

require 'spec_helper'

describe 'check_mk::agent' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }

    context "with default parameters set on #{os}" do
      it {
        expect(subject).to compile
        expect(subject).to contain_class('check_mk::agent')
        expect(subject).to contain_class('check_mk::agent::install')
        expect(subject).to contain_class('check_mk::agent::config').that_requires('Class[check_mk::agent::install]')
        expect(subject).to contain_class('check_mk::agent::service').that_subscribes_to('Class[check_mk::agent::config]')
      }
    end

    context 'with user set' do
      let(:params) do
        {
          user: 'foo'
        }
      end

      it 'group defaults to user' do
        expect(subject).to contain_class('check_mk::agent::config').with_group('foo')
      end
    end

    context "with mrpe_checks on #{os}" do
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
        expect(subject).to compile
        expect(subject).to contain_class('check_mk::agent')
        expect(subject).to contain_class('check_mk::agent::install')
        expect(subject).to contain_class('check_mk::agent::config').that_requires('Class[check_mk::agent::install]')
      }

      it { is_expected.to have_check_mk__agent__mrpe_resource_count(2) }
    end
  end
end
