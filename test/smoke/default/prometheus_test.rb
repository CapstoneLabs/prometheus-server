# # encoding: utf-8

# Inspec test for recipe prometheus-server::prometheus

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('prometheus') do
  it { should exist }
  its('group') { should eq 'prometheus' }
  its('home') { should eq '/home/prometheus' }
  its('shell') { should eq '/bin/false' }
end

describe directory('/etc/prometheus') do
  it { should exist }
  its('owner') { should eq 'prometheus' }
  its('group') { should eq 'prometheus' }
end

describe directory('/etc/prometheus/consoles') do
  it { should exist }
  its('owner') { should eq 'prometheus' }
  its('group') { should eq 'prometheus' }
end

describe directory('/etc/prometheus/console_libraries') do
  it { should exist }
  its('owner') { should eq 'prometheus' }
  its('group') { should eq 'prometheus' }
end

describe directory('/var/lib/prometheus') do
  it { should exist }
  its('owner') { should eq 'prometheus' }
  its('group') { should eq 'prometheus' }
end

describe file('/usr/local/bin/prometheus') do
  it { should exist }
  its('owner') { should eq 'prometheus' }
  its('group') { should eq 'prometheus' }
end

describe file('/usr/local/bin/promtool') do
  it { should exist }
  its('owner') { should eq 'prometheus' }
  its('group') { should eq 'prometheus' }
end

describe file('/etc/prometheus/prometheus.yml') do
  it { should exist }
  its('owner') { should eq 'prometheus' }
  its('group') { should eq 'prometheus' }
end

describe systemd_service('prometheus') do
  it { should be_enabled }
  it { should be_running }
  it { should be_installed }
end

describe port(9090) do
  it { should be_listening }
  its('processes') { should include 'prometheus' }
end

describe processes('prometheus') do
  its('users') { should eq ['prometheus'] }
end
