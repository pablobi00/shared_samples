require 'spec_helper'

describe 'apache_stack' do
  on_supported_os(facts: RSpec.configuration.default_facts).each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_package('httpd').with(
          ensure: 'installed',
        )
      end

      it do
        is_expected.to contain_file('/etc/httpd/conf.d/puppet_managed.conf').with(
          ensure: 'file',
          owner: 'root',
          group: 'root',
          mode: '0644',
        )
      end

      it 'creates the managed Apache config with the correct content' do
        expect(subject).to contain_file('/etc/httpd/conf.d/puppet_managed.conf').with_content(%r{^# Managed by Puppet — do not edit manually})
      end

      it do
        is_expected.to contain_service('httpd').with(
          ensure: 'running',
          enable: true,
        )
      end

      it do
        is_expected.to contain_file('/etc/httpd/conf.d/puppet_managed.conf').that_requires('Package[httpd]')
      end

      it do
        is_expected.to contain_file('/etc/httpd/conf.d/puppet_managed.conf').that_notifies('Service[httpd]')
      end

      it do
        is_expected.to contain_service('httpd').that_requires('Package[httpd]')
      end
    end
  end
end
