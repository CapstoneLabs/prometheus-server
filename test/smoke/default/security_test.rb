# # encoding: utf-8

# Inspec test for recipe prometheus-server::add_security

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('nginx') do
  it { should be_installed }
end

describe package('apache2-utils') do
  it { should be_installed }
end

describe file('/etc/nginx/sites-available/prometheus') do
  it { should exist }
end

describe file('/etc/nginx/sites-enabled/prometheus') do
  it { should exist }
end

describe service('nginx') do
  it { should be_running }
  it { should be_enabled }
  it { should be_installed }
end

describe port('80') do
  it { should be_listening }
  its('processes') { should include 'nginx' }
end
