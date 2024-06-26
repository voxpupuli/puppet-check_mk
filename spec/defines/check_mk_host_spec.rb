# frozen_string_literal: true

require 'spec_helper'
describe 'check_mk::host', type: :define do
  let :title do
    'host'
  end

  context 'with empty host_tags array' do
    let :params do
      { target: 'target' }
    end

    it { is_expected.to contain_check_mk__host('host') }

    it {
      expect(subject).to contain_concat__fragment('check_mk-host').with(target: 'target',
                                                                        content: %r{^  'host',\n$},
                                                                        order: 11)
    }
  end

  context 'with custom host_tags' do
    let :params do
      {
        target: 'target',
        host_tags: %w[tag1 tag2]
      }
    end

    it { is_expected.to contain_check_mk__host('host') }

    it {
      expect(subject).to contain_concat__fragment('check_mk-host').with(target: 'target',
                                                                        content: %r{^  'host|tag1|tag2',\n$},
                                                                        order: 11)
    }
  end
end
