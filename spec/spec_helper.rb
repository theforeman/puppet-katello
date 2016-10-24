# This file is managed centrally by modulesync
#   https://github.com/Katello/foreman-installer-modulesync

require 'puppetlabs_spec_helper/module_spec_helper'

require 'rspec-puppet-facts'
include RspecPuppetFacts

                                                    # Original fact sources:
add_custom_fact :concat_basedir, '/tmp'             # puppetlabs-concat
add_custom_fact :mongodb_version, '2.4.14'          # puppetlabs-mongodb
add_custom_fact :root_home, '/root'                 # puppetlabs-stdlib
add_custom_fact :puppetversion, Puppet.version      # Facter, but excluded from rspec-puppet-facts
add_custom_fact :puppet_environmentpath, Gem::Version.new(Puppet.version) >= Gem::Version.new('4.0') ? '/etc/puppetlabs/code/environments' : '' # puppetlabs-stdlib

# Workaround for no method in rspec-puppet to pass undef through :params
class Undef
  def inspect; 'undef'; end
end

# Running tests with the ONLY_OS environment variable set
# limits the tested platforms to the specified values.
# Example: ONLY_OS=centos-7-x86_64,ubuntu-14-x86_64
def only_test_os
  if ENV.key?('ONLY_OS')
    ENV['ONLY_OS'].split(',')
  end
end

# Running tests with the EXCLUDE_OS environment variable set
# limits the tested platforms to all but the specified values.
# Example: EXCLUDE_OS=centos-7-x86_64,ubuntu-14-x86_64
def exclude_test_os
  if ENV.key?('EXCLUDE_OS')
    ENV['EXCLUDE_OS'].split(',')
  end
end

def get_content(subject, title)
  content = subject.resource('file', title).send(:parameters)[:content]
  content.split(/\n/).reject { |line| line =~ /(^#|^$|^\s+#)/ }
end

def verify_exact_contents(subject, title, expected_lines)
  expect(get_content(subject, title)).to eq(expected_lines)
end

def verify_concat_fragment_contents(subject, title, expected_lines)
  content = subject.resource('concat::fragment', title).send(:parameters)[:content]
  expect(content.split("\n") & expected_lines).to eq(expected_lines)
end

def verify_concat_fragment_exact_contents(subject, title, expected_lines)
  content = subject.resource('concat::fragment', title).send(:parameters)[:content]
    expect(content.split(/\n/).reject { |line| line =~ /(^#|^$|^\s+#)/ }).to eq(expected_lines)
end
