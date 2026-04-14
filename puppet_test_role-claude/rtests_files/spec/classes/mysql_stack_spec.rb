require 'spec_helper'

describe 'mysql_stack' do
  on_supported_os(facts: RSpec.configuration.default_facts).each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to contain_package('mysql-server').with(
          ensure: 'installed',
        )
      end

      it do
        is_expected.to contain_service('mysqld').with(
          ensure: 'running',
          enable: true,
        )
      end

      it do
        is_expected.to contain_exec('set-mysql-root-password').with(
          command: "/usr/bin/mysqladmin -u root password 'Ch4ng3M3!'",
          unless: "/usr/bin/mysqladmin -u root -p'Ch4ng3M3!' status",
          require: 'Service[mysqld]',
        )
      end
    end
  end
end
