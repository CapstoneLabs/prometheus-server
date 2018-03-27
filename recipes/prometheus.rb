#
# Cookbook:: prometheus-server
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# create system user
user 'prometheus' do
  comment 'prometheus user'
  system true
  shell '/bin/false'
end

# create folder structure
directory '/etc/prometheus' do
  owner 'prometheus'
  group 'prometheus'
  mode '0755'
  action :create
end

directory '/var/lib/prometheus' do
  owner 'prometheus'
  group 'prometheus'
  mode '0755'
  action :create
end

# download compressed file
remote_file "/tmp/#{node['prometheus']['folders']['prometheus']}.tar.gz" do
  not_if { ::File.exist?('/usr/local/bin/prometheus') }
  source node['prometheus']['downloads']['prometheus']
end

# create directory
directory "/tmp/#{node['prometheus']['folders']['prometheus']}"

# decompress tar
execute 'extract prometheus compressed file' do
  not_if { ::File.exist?('/usr/local/bin/prometheus') }
  command "tar xvf /tmp/#{node['prometheus']['folders']['prometheus']}.tar.gz -C /tmp"
end

# copy binary
ruby_block "cp /tmp/#{node['prometheus']['folders']['prometheus']}/prometheus /usr/local/bin" do
  not_if { ::File.exist?('/usr/local/bin/prometheus') }
  block do
    require 'fileutils'
    FileUtils.cp "/tmp/#{node['prometheus']['folders']['prometheus']}/prometheus", '/usr/local/bin/'
  end
end

# set perms
file '/usr/local/bin/prometheus' do
  owner 'prometheus'
  group 'prometheus'
end

# copy binary
ruby_block "cp /tmp/#{node['prometheus']['folders']['prometheus']}/promtool /usr/local/bin" do
  not_if { ::File.exist?('/usr/local/bin/promtool') }
  block do
    require 'fileutils'
    FileUtils.cp "/tmp/#{node['prometheus']['folders']['prometheus']}/promtool", '/usr/local/bin/'
  end
end

# set perms
file '/usr/local/bin/promtool' do
  owner 'prometheus'
  group 'prometheus'
end

# copy directories
ruby_block "cp /tmp/#{node['prometheus']['folders']['prometheus']}/consoles /etc/prometheus/consoles" do
  not_if { ::File.exist?('/etc/prometheus/consoles') }
  block do
    require 'fileutils'
    FileUtils.cp_r "/tmp/#{node['prometheus']['folders']['prometheus']}/consoles", '/etc/prometheus'
  end
end

directory '/etc/prometheus/consoles' do
  owner 'prometheus'
  group 'prometheus'
end

ruby_block "cp /tmp/#{node['prometheus']['folders']['prometheus']}/console_libraries /etc/prometheus/console_libraries" do
  not_if { ::File.exist?('/etc/prometheus/console_libraries') }
  block do
    require 'fileutils'
    FileUtils.cp_r "/tmp/#{node['prometheus']['folders']['prometheus']}/console_libraries", '/etc/prometheus'
  end
end

directory '/etc/prometheus/console_libraries' do
  owner 'prometheus'
  group 'prometheus'
end
# end prometheus copy

# copy prometheus.yml from files
cookbook_file '/etc/prometheus/prometheus.yml' do
  source 'prometheus.yml'
  owner 'prometheus'
  group 'prometheus'
end

# create systemd unit file prometheus.service
systemd_unit 'prometheus.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Prometheus
  Wants=network-online.target
  After=network-online.target

  [Service]
  User=prometheus
  Group=prometheus
  Type=simple
  ExecStart=/usr/local/bin/prometheus \
      --config.file /etc/prometheus/prometheus.yml \
      --storage.tsdb.path /var/lib/prometheus/ \
      --web.console.templates=/etc/prometheus/consoles \
      --web.console.libraries=/etc/prometheus/console_libraries

  [Install]
  WantedBy=multi-user.target
  EOU

  action [:create, :enable]
end

# re/start prometheus
service 'prometheus' do
  action [:start, :restart]
end
