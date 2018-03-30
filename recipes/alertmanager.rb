#
# Cookbook:: prometheus-server
# Recipe:: alertsmanager
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# create system user
user 'alertmanager' do
  comment 'alertmanager user'
  system true
  shell '/bin/false'
end

# create folder to store config
directory '/etc/alertmanager' do
 owner 'alertmanager'
 group 'alertmanager'
 mode '0755'
 action :create
end

# create folder to store config
directory '/var/lib/alertmanager/data' do
 owner 'alertmanager'
 group 'alertmanager'
 mode '0755'
 recursive true
 action :create
end

# download compressed file
remote_file "/tmp/#{node['prometheus']['folders']['alertmanager']}.tar.gz" do
  not_if { ::File.exist?('/usr/local/bin/alertmanager') }
  source node['prometheus']['downloads']['alertmanager']
end

# create directory
directory "/tmp/#{node['prometheus']['folders']['alertmanager']}"

# decompress tar
execute 'extract prometheus compressed file' do
  not_if { ::File.exist?('/usr/local/bin/prometheus') }
  command "tar xvf /tmp/#{node['prometheus']['folders']['alertmanager']}.tar.gz -C /tmp"
end

# copy binaries
ruby_block "cp /tmp/#{node['prometheus']['folders']['alertmanager']}/alertmanager /usr/local/bin" do
  not_if { ::File.exist?('/usr/local/bin/alertmanager') }
  block do
    require 'fileutils'
    FileUtils.cp "/tmp/#{node['prometheus']['folders']['alertmanager']}/alertmanager", '/usr/local/bin/'
  end
end

# set perms
file '/usr/local/bin/alertmanager' do
  owner 'alertmanager'
  group 'alertmanager'
end

# generate alertmanager.yml
template '/etc/alertmanager/alertmanager.yml' do
  source 'alertmanager.erb'
  owner 'alertmanager'
  group 'alertmanager'
  notifies :restart, "service[alertmanager]"
end

# create systemd unit file alertmanager.service
systemd_unit 'alertmanager.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=AlertManager
  Wants=network-online.target
  After=network-online.target

  [Service]
  User=alertmanager
  Group=alertmanager
  Type=simple
  ExecStart=/usr/local/bin/alertmanager \
      --config.file /etc/alertmanager/alertmanager.yml \
      --storage.path="/var/lib/alertmanager/data/"

  [Install]
  WantedBy=multi-user.target
  EOU

  action [:create, :enable]
  notifies :restart, "service[alertmanager]"
end

# re/start alertmanager
service 'alertmanager' do
  restart_command "systemctl restart alertmanager"
  action :nothing
end
