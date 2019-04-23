require 'spec_helper_acceptance'

describe 'check_mk class' do
  packagename = case fact('os.family')
                when 'Debian'
                  'check-mk-raw-1.5.0p15_0.' + fact('os.distro.codename') + '_amd64.deb'
                when 'RedHat'
                  'check-mk-raw-1.5.0p15-el' + fact('os.release.major') + '-38.x86_64.rpm'
                end
  packagename_agent = case fact('os.family')
                      when 'Debian'
                        'check-mk-agent_1.5.0p15-1_all.deb'
                      when 'RedHat'
                        'check-mk-agent-1.5.0p15-1.noarch.rpm'
                      end
  context 'minimal parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'check_mk':
        filestore => 'https://mathias-kettner.de/support/1.5.0p15/',
        package   => '#{packagename}',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe port(80) do
      it { is_expected.to be_listening }
    end

    it 'responds with the login page' do
      shell('/usr/bin/curl http://127.0.0.1/monitoring/check_mk/login.py') do |r|
        expect(r.stdout).to match(%r{Mathias Kettner})
      end
    end
  end
  context 'minimal parameters for agent' do
    it 'works idempotently with no errors' do
      pp = <<-EOS
      class { 'check_mk::agent':
        filestore => 'http://127.0.0.1/monitoring/check_mk/agents/',
        package   => '#{packagename_agent}',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe port(6556) do
      it { is_expected.to be_listening }
    end
  end
end
