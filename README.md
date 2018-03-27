# prometheus-server

We found there's no working Prometheus cookbooks out there so we wrote our own.

## Testing

Currently only tested on Ubuntu 16.04

## Attributes

Versions are established in the default attributes file. You only need to edit the version numbers and everything else will be done for you.

## Recipes

### default

Installs all the other recipes.

### prometheus

Installs and runs Prometheus server as a systemd service.

### security

Sets up nginx to proxy requests to Prometheus with basic auth.

### alertmanager

Installs and runs AlertManager server as a systemd service.

### node_exporter

Installs and runs NodeExporter as a systemd service.

### grafana

> **Note**: auth.github utilizes the ['server']['domain'] attribute. Make sure you set it correctly or the *redirect_uri* for GitHub will not be set correctly and logins will fail.

Installs and runs Grafana as a systemd service.

* Use [these attributes](https://github.com/chef-cookbooks/chef-grafana/blob/master/attributes/default.rb) to configure Grafana.

## To Do
* Testing for AlertManager recipe
* Testing for Prometheus recipe
* Testing for Grafana recipe
* Testing for Node_Exporter recipe
* Testing for Security recipe
* Convert Cookbook files to Templates and use attributes
* Clean up downloaded compressed files and folders

## Development
* If you plan to work on the cookbook don't forget to set environment variables *SLACK_API_URL*, *CLIENT_ID* and *CLIENT_SECRET*. Check out .kitchen.yml for more info.

PR's welcome :)
