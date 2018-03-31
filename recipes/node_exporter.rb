#
# Cookbook:: prometheus-server
# Recipe:: node_exporter
#
# Copyright:: 2018, Capstone Metering LLC, Apache License 2.0.

# create system user
user 'node_exporter' do
  comment 'prometheus node_exporter user'
  system true
  shell '/bin/false'
end

# download compressed file
remote_file "/tmp/#{node['prometheus']['folders']['node_exporter']}.tar.gz" do
  not_if { ::File.exist?('/usr/local/bin/node_exporter') }
  source node['prometheus']['downloads']['node_exporter']
end

# create directory
directory "/tmp/#{node['prometheus']['folders']['node_exporter']}"

# decompress tar
execute "tar xvf /tmp/#{node['prometheus']['folders']['node_exporter']}.tar.gz -C /tmp" do
  not_if { ::File.exist?('/usr/local/bin/node_exporter') }
  command "tar xvf /tmp/#{node['prometheus']['folders']['node_exporter']}.tar.gz -C /tmp"
end

# move binary
ruby_block "cp /tmp/#{node['prometheus']['folders']['node_exporter']}/node_exporter /usr/local/bin" do
  not_if { ::File.exist?('/usr/local/bin/node_exporter') }
  block do
    require 'fileutils'
    FileUtils.cp "/tmp/#{node['prometheus']['folders']['node_exporter']}/node_exporter", '/usr/local/bin/'
  end
end

# set perms
file '/usr/local/bin/node_exporter' do
  owner 'node_exporter'
  group 'node_exporter'
  notifies :restart, "service[node_exporter]"
end

# create systemd unit file node_exporter.service
systemd_unit 'node_exporter.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Node Exporter
  Wants=network-online.target
  After=network-online.target

  [Service]
  User=node_exporter
  Group=node_exporter
  Type=simple
  ExecStart=/usr/local/bin/node_exporter \
    --collector.filesystem.ignored-mount-points="^/(sys|proc|dev|host|etc|var/lib/docker/containers|var/lib/docker/overlay2|run/docker/netns.*)($$|/)"

  [Install]
  WantedBy=multi-user.target
  EOU

  action [:create, :enable]
  notifies :restart, "service[node_exporter]"
end

# re/start node_exporter
service 'node_exporter' do
  restart_command "systemctl restart node_exporter"
  action :nothing
end
