#
# Cookbook:: prometheus-server
# Recipe:: add_security
#
# Copyright:: 2018, The Authors, All Rights Reserved.

apt_update 'update'

package 'nginx'
package 'apache2-utils'

# for some reason this is needed
include_recipe 'htpasswd::default'

# setup users
node['prometheus']['users'].each do |username|
  htpasswd "/etc/nginx/.htpasswd" do
    user username
    password chef_vault_item("users", username)["password"]
  end
end

# copy prometheus.yaml from files
cookbook_file '/etc/nginx/sites-available/prometheus' do
  source 'prometheus.nginx'
end

# remove the default nginx file
ruby_block "rm /etc/nginx/sites-available/default" do
  only_if { ::File.exist?('/etc/nginx/sites-available/default') }
  block do
    require 'fileutils'
    FileUtils.rm ['/etc/nginx/sites-available/default', '/etc/nginx/sites-enabled/default']
  end
end

# create symlink
ruby_block "ln -s /etc/nginx/sites-available/prometheus /etc/nginx/sites-enabled/prometheus" do
  not_if { ::File.exist?('/etc/nginx/sites-enabled/prometheus') }
  block do
    require 'fileutils'
    FileUtils.ln_s '/etc/nginx/sites-available/prometheus', '/etc/nginx/sites-enabled/prometheus'
  end
end

service 'nginx' do
  action :reload
end
