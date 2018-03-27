name 'prometheus-server'
maintainer 'Capstone Metering, LLC'
maintainer_email 'matt.ouille@capstonemetering.com'
license 'Apache 2.0'
description 'Installs/Configures prometheus-server'
long_description 'Installs/Configures prometheus-server'
version '0.1.4'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'chef-vault', '~> 3.0.0'
depends 'htpasswd', '~> 0.3.0'
depends 'chef-grafana', '~> 0.5.0'

issues_url 'https://github.com/CapstoneLabs/prometheus-server/issues'
source_url 'https://github.com/CapstoneLabs/prometheus-server'
