# versions to download
default['prometheus']['versions']['prometheus'] = '2.2.1'
default['prometheus']['versions']['alertmanager'] = '0.14.0'
default['prometheus']['versions']['node_exporter'] = '0.15.2'
default['prometheus']['versions']['push_gateway'] = '0.4.0'
default['prometheus']['versions']['statsd_exporter'] = '0.6.0'

# interpolate download url
default['prometheus']['downloads']['prometheus'] = "https://github.com/prometheus/prometheus/releases/download/v#{default['prometheus']['versions']['prometheus']}/prometheus-#{default['prometheus']['versions']['prometheus']}.linux-amd64.tar.gz"
default['prometheus']['downloads']['alertmanager'] = "https://github.com/prometheus/alertmanager/releases/download/v#{default['prometheus']['versions']['alertmanager']}/alertmanager-#{default['prometheus']['versions']['alertmanager']}.linux-amd64.tar.gz"
default['prometheus']['downloads']['node_exporter'] = "https://github.com/prometheus/node_exporter/releases/download/v#{default['prometheus']['versions']['node_exporter']}/node_exporter-#{default['prometheus']['versions']['node_exporter']}.linux-amd64.tar.gz"
default['prometheus']['downloads']['push_gateway'] = "https://github.com/prometheus/pushgateway/releases/download/v#{default['prometheus']['versions']['push_gateway']}/pushgateway-#{default['prometheus']['versions']['push_gateway']}.linux-amd64.tar.gz"
default['prometheus']['downloads']['statsd_exporter'] = "https://github.com/prometheus/statsd_exporter/releases/download/v#{default['prometheus']['versions']['statsd_exporter']}/statsd_exporter-#{default['prometheus']['versions']['statsd_exporter']}.linux-amd64.tar.gz"

# interpolate folder names after we extract
default['prometheus']['folders']['prometheus'] = "prometheus-#{default['prometheus']['versions']['prometheus']}.linux-amd64"
default['prometheus']['folders']['alertmanager'] = "alertmanager-#{default['prometheus']['versions']['alertmanager']}.linux-amd64"
default['prometheus']['folders']['node_exporter'] = "node_exporter-#{default['prometheus']['versions']['node_exporter']}.linux-amd64"
default['prometheus']['folders']['push_gateway'] = "pushgateway-#{default['prometheus']['versions']['push_gateway']}.linux-amd64"
default['prometheus']['folders']['statsd_exporter'] = "statsd_exporter-#{default['prometheus']['versions']['statsd_exporter']}.linux-amd64"

# security users
default['htpasswd']['install_method'] = 'ruby'
default['prometheus']['users'] = ['']

# grafana
default['chef-grafana']['config']['auth.anonymous']['enabled'] = false
default['chef-grafana']['config']['auth.github']['scopes'] = 'user:email,read:org'
default['chef-grafana']['install']['version'] = '5.0.3'

# alertmanager
default['prometheus']['alertmanager']['slack_api_url'] = nil
