require 'spec_helper'
describe 'check_mk::hostgroup' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with hostgroups, host_tags and description' do
        hostgroups = {
          'TEST_HOSTGROUP' => {
            'host_tags' => %w[
              tag1
              tag2
            ],
            'description' => 'TEST_DESCRIPTION'
          }
        }
        let :title do
          'TEST_HOSTGROUP'
        end
        let :params do
          {
            dir: '/dir',
            hostgroups: hostgroups,
            target: 'target'
          }
        end

        it { is_expected.to contain_check_mk__hostgroup('TEST_HOSTGROUP') }
        it {
          is_expected.to contain_concat__fragment('check_mk-hostgroup-TEST_HOSTGROUP').with(target: 'target',
                                                                                            content: %r{^  \( 'TEST_HOSTGROUP', \[ 'tag1', 'tag2' \], ALL_HOSTS \),\n$},
                                                                                            order: 21)
        }
        expected_file_content = <<EOS
define hostgroup {
  hostgroup_name TEST_HOSTGROUP
  alias TEST_DESCRIPTION
}
EOS
        it {
          is_expected.to contain_file('/dir/TEST_HOSTGROUP.cfg').with(ensure: 'file',
                                                                      content: expected_file_content)
        }
      end

      context 'with hostgroups without description' do
        hostgroups = {
          'TEST_HOUSTGROUP_WITH_UNDERSCORES' => {
            'host_tags' => %w[
              tag1
              tag2
            ]
          }
        }
        let :title do
          'TEST_HOUSTGROUP_WITH_UNDERSCORES'
        end
        let :params do
          {
            dir: '/dir',
            hostgroups: hostgroups,
            target: '/target'
          }
        end

        it { is_expected.to contain_check_mk__hostgroup('TEST_HOUSTGROUP_WITH_UNDERSCORES') }
        it {
          is_expected.to contain_concat__fragment('check_mk-hostgroup-TEST_HOUSTGROUP_WITH_UNDERSCORES').with(target: '/target',
                                                                                                              content: %r{^  \( 'TEST_HOUSTGROUP_WITH_UNDERSCORES', \[ 'tag1', 'tag2' \], ALL_HOSTS \),\n$},
                                                                                                              order: 21)
        }
        expected_file_content = <<EOS
define hostgroup {
  hostgroup_name TEST_HOUSTGROUP_WITH_UNDERSCORES
  alias TEST HOUSTGROUP_WITH_UNDERSCORES
}
EOS
        it {
          is_expected.to contain_file('/dir/TEST_HOUSTGROUP_WITH_UNDERSCORES.cfg').with(ensure: 'file',
                                                                                        content: expected_file_content)
        }
      end
    end
  end
end
