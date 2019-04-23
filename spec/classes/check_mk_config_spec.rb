require 'spec_helper'

describe 'check_mk::config' do
  on_supported_os.each do |os, os_facts|
    context "with site set on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { site: 'TEST_SITE' } }

      it {
        is_expected.to compile

        is_expected.to contain_class('check_mk::config')

        is_expected.to contain_file('/omd/sites/TEST_SITE/etc/nagios/local').with(
          'ensure' => 'directory',
          'owner'  => 'TEST_SITE',
          'group'  => 'TEST_SITE'
        )

        is_expected.to contain_file_line('nagios-add-check_mk-cfg_dir').with(
          'ensure'  => 'present',
          'line'    => 'cfg_dir=/omd/sites/TEST_SITE/etc/nagios/local',
          'path'    => '/omd/sites/TEST_SITE/etc/nagios/nagios.cfg'
        ).that_requires('File[/omd/sites/TEST_SITE/etc/nagios/local]')

        is_expected.to contain_file('/omd/sites/TEST_SITE/etc/check_mk/all_hosts_static').with(
          'ensure'  => 'file',
          'content' => ''
        )

        is_expected.to contain_concat('/omd/sites/TEST_SITE/etc/check_mk/main.mk').with(
          'owner'  => 'TEST_SITE',
          'group'  => 'TEST_SITE',
          'mode'   => '0644'
        )

        is_expected.to contain_concat__fragment('all_hosts-header').with(
          'target'  => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          'content' => %r{all_hosts = \[\n},
          'order'   => 10
        )

        is_expected.to contain_concat__fragment('all_hosts-footer').with(
          'target'  => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          'content' => %r{\]\n},
          'order'   => 19
        )

        is_expected.to contain_concat__fragment('all-hosts-static').with(
          'source' => '/omd/sites/TEST_SITE/etc/check_mk/all_hosts_static',
          'target' => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          'order'  => 18
        )

        is_expected.to contain_concat__fragment('check_mk-local-config').with(
          'source' => '/omd/sites/TEST_SITE/etc/check_mk/main.mk.local',
          'target' => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          'order'  => 99
        )

        is_expected.to contain_exec('check_mk-reload').with(
          'command'     => '/bin/su -l -c \'/omd/sites/TEST_SITE/bin/check_mk --reload\' TEST_SITE',
          'refreshonly' => true
        )

        is_expected.not_to contain_file('/omd/sites/TEST_SITE/etc/nagios/local/hostgroups')
        is_expected.not_to contain_concat__fragment('host_groups-header')
        is_expected.not_to contain_concat__fragment('host_groups-footer')
      }
    end
    context "with site set on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          site: 'TEST_SITE',
          host_groups: {
            group1: {
              host_tags: []
            },
            group2: {
              host_tags: []
            }
          }
        }
      end

      it {
        is_expected.to compile
        is_expected.to contain_class('check_mk::config')
        is_expected.to contain_file('/omd/sites/TEST_SITE/etc/nagios/local/hostgroups').with(
          'ensure' => 'directory'
        )
        is_expected.to contain_concat__fragment('host_groups-header').with(
          'target'  => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          'content' => %r{host_groups = \[\n},
          'order'   => 20
        )
        is_expected.to contain_concat__fragment('host_groups-footer').with(
          'target'  => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          'content' => %r{\]\n},
          'order'   => 29
        )
        is_expected.to contain_check_mk__hostgroup('group1').with(
          'dir'         => '/omd/sites/TEST_SITE/etc/nagios/local/hostgroups',
          'host_groups' => params['host_groups'],
          'target'      => '/omd/sites/TEST_SITE/etc/check_mk/main.mk'
        )
        is_expected.to contain_check_mk__hostgroup('group2').with(
          'dir'         => '/omd/sites/TEST_SITE/etc/nagios/local/hostgroups',
          'host_groups' => params['host_groups'],
          'target'      => '/omd/sites/TEST_SITE/etc/check_mk/main.mk'
        )
      }
    end
  end
end
