# frozen_string_literal: true

require 'spec_helper'

describe 'check_mk::agent::service' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'when using systemd' do
        let(:params) { { service_name: 'check_mk' } }

        it {
          expect(subject).to contain_service('check_mk.socket').with(
            'ensure' => 'running',
            'enable' => true
          )
        }

        context 'with non-standard service name' do
          let(:params) do
            super().merge(service_name: 'custom-check-mk-agent')
          end

          it do
            expect(subject).to contain_service('custom-check-mk-agent.socket')
          end
        end
      end
    end
  end
end
