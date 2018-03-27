# # encoding: utf-8

# Inspec test for recipe prometheus-server::node_exporter

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('node_exporter') do
  it { should exist }
  its('group') { should eq 'node_exporter' }
  its('home') { should eq '/home/node_exporter' }
  its('shell') { should eq '/bin/false' }
end

describe file('/usr/local/bin/node_exporter') do
  it { should exist }
  its('owner') { should eq 'node_exporter' }
  its('group') { should eq 'node_exporter' }
end

describe systemd_service('node_exporter') do
  it { should be_enabled }
  it { should be_running }
  it { should be_installed }
end

describe port(9100) do
  it { should be_listening }
  its('processes') { should include 'node_exporter' }
end

describe processes('node_exporter') do
  its('users') { should eq ['node_exporter'] }
end
