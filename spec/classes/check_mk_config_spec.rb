# frozen_string_literal: true

require 'spec_helper'

describe 'check_mk::config' do
  on_supported_os.each do |os, os_facts|
    context "with site set on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { monitoring_site: 'TEST_SITE' } }

      it {
        expect(subject).to compile

        expect(subject).to contain_class('check_mk::config')

        expect(subject).to contain_file('/omd/sites/TEST_SITE/etc/nagios/local').with(
          'ensure' => 'directory',
          'owner' => 'TEST_SITE',
          'group' => 'TEST_SITE'
        )

        expect(subject).to contain_file_line('nagios-add-check_mk-cfg_dir').with(
          'ensure' => 'present',
          'line' => 'cfg_dir=/omd/sites/TEST_SITE/etc/nagios/local',
          'path' => '/omd/sites/TEST_SITE/etc/nagios/nagios.cfg'
        ).that_requires('File[/omd/sites/TEST_SITE/etc/nagios/local]')

        expect(subject).to contain_file('/omd/sites/TEST_SITE/etc/check_mk/all_hosts_static').with(
          'ensure' => 'file',
          'content' => ''
        )

        expect(subject).to contain_concat('/omd/sites/TEST_SITE/etc/check_mk/main.mk').with(
          'owner' => 'TEST_SITE',
          'group' => 'TEST_SITE',
          'mode' => '0644'
        )

        expect(subject).to contain_concat__fragment('all_hosts-header').with(
          'target' => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          'content' => %r{all_hosts = \[\n},
          'order' => 10
        )

        expect(subject).to contain_concat__fragment('all_hosts-footer').with(
          'target' => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          'content' => %r{\]\n},
          'order' => 19
        )

        expect(subject).to contain_concat__fragment('all-hosts-static').with(
          'source' => '/omd/sites/TEST_SITE/etc/check_mk/all_hosts_static',
          'target' => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          'order' => 18
        )

        expect(subject).to contain_concat__fragment('check_mk-local-config').with(
          'source' => '/omd/sites/TEST_SITE/etc/check_mk/main.mk.local',
          'target' => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          'order' => 99
        )

        expect(subject).to contain_exec('check_mk-reload').with(
          'command' => '/bin/su -l -c \'/omd/sites/TEST_SITE/bin/check_mk --reload\' TEST_SITE',
          'refreshonly' => true
        )

        expect(subject).not_to contain_file('/omd/sites/TEST_SITE/etc/nagios/local/hostgroups')
        expect(subject).not_to contain_concat__fragment('host_groups-header')
        expect(subject).not_to contain_concat__fragment('host_groups-footer')
      }
    end

    context "with site set on #{os} and two host groups" do
      let(:facts) { os_facts }
      let(:params) do
        {
          monitoring_site: 'TEST_SITE',
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
        expect(subject).to compile
        expect(subject).to contain_class('check_mk::config')
        expect(subject).to contain_file('/omd/sites/TEST_SITE/etc/nagios/local/hostgroups').with(
          'ensure' => 'directory'
        )
        expect(subject).to contain_concat__fragment('host_groups-header').with(
          'target' => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          'content' => %r{host_groups = \[\n},
          'order' => 20
        )
        expect(subject).to contain_concat__fragment('host_groups-footer').with(
          'target' => '/omd/sites/TEST_SITE/etc/check_mk/main.mk',
          'content' => %r{\]\n},
          'order' => 29
        )
        expect(subject).to contain_check_mk__hostgroup('group1').with(
          'dir' => '/omd/sites/TEST_SITE/etc/nagios/local/hostgroups',
          'host_groups' => params['host_groups'],
          'target' => '/omd/sites/TEST_SITE/etc/check_mk/main.mk'
        )
        expect(subject).to contain_check_mk__hostgroup('group2').with(
          'dir' => '/omd/sites/TEST_SITE/etc/nagios/local/hostgroups',
          'host_groups' => params['host_groups'],
          'target' => '/omd/sites/TEST_SITE/etc/check_mk/main.mk'
        )
      }
    end
  end
end
