# # encoding: utf-8

# Inspec test for recipe prometheus-server::alertsmanager

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('alertmanager') do
  it { should exist }
  its('group') { should eq 'alertmanager' }
  its('home') { should eq '/home/alertmanager' }
  its('shell') { should eq '/bin/false' }
end

describe directory('/etc/alertmanager') do
  it { should exist }
  its('owner') { should eq 'alertmanager' }
  its('group') { should eq 'alertmanager' }
end

describe directory('/var/lib/alertmanager/data') do
  it { should exist }
  its('owner') { should eq 'alertmanager' }
  its('group') { should eq 'alertmanager' }
end

describe file('/usr/local/bin/alertmanager') do
  it { should exist }
  its('owner') { should eq 'alertmanager' }
  its('group') { should eq 'alertmanager' }
end

describe file('/etc/alertmanager/alertmanager.yml') do
  it { should exist }
  its('owner') { should eq 'alertmanager' }
  its('group') { should eq 'alertmanager' }
end

describe systemd_service('alertmanager') do
  it { should be_enabled }
  it { should be_running }
  it { should be_installed }
end

describe port(9093) do
  it { should be_listening }
  its('processes') { should include 'alertmanager' }
end

describe processes('alertmanager') do
  its('users') { should eq ['alertmanager'] }
end
