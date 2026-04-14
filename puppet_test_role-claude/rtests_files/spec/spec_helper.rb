# frozen_string_literal: true

require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
require 'yaml'
require 'deep_merge'

RSpec.configure do |c|
  c.mock_with :rspec

  default_fact_file = File.expand_path(File.join(__dir__, 'default_facts.yml'))
  default_facts = File.exist?(default_fact_file) ? YAML.safe_load(File.read(default_fact_file), permitted_classes: [], permitted_symbols: [], aliases: true) : {}
  default_facts ||= {}

  c.default_facts = default_facts.merge(
    osfamily: 'RedHat',
    operatingsystem: 'Rocky',
    operatingsystemmajrelease: '8',
    operatingsystemrelease: '8.6',
    architecture: 'x86_64',
  )

  c.module_path = [File.expand_path('../../modules', __dir__)]

  c.before(:each) do
    Puppet.settings[:strict] = :warning
    Puppet.settings[:strict_variables] = true
  end

  c.after(:suite) do
    RSpec::Puppet::Coverage.report!(0)
  end
end
