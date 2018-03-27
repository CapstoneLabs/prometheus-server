# # encoding: utf-8

# Inspec test for recipe prometheus-server::grafana

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('grafana-server') do
  it { should be_enabled }
  it { should be_running }
  it { should be_installed }
end

describe port(3000) do
  it { should be_listening }
  its('processes') { should include 'grafana-server' }
end

describe file('/etc/grafana/grafana.ini') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
end
