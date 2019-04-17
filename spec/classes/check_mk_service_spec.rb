require 'spec_helper'
describe 'check_mk::service', type: :class do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('check_mk::service') }
    it {
      is_expected.to contain_service('httpd').with(ensure: 'running',
                                                   enable: 'true')
    }
    it {
      is_expected.to contain_service('omd').with(ensure: 'running',
                                                 enable: 'true')
    }
  end
end
