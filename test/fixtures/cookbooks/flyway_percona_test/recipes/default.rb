node.override['percona']['encrypted_data_bag']                          = 'flyway'
node.override['percona']['server']['role']                              = 'master'
node.override['percona']['server']['datadir']                           = '/data/mysql'
node.override['percona']['server']['replication']['username']           = 'replication'
node.override['percona']['server']['query_cache_size']                  = '256M'
node.override['percona']['server']['query_cache_type']                  = 'ON'

include_recipe 'flyway_percona::server'

chef_gem 'chef-rewind'
require 'chef/rewind'

rewind template: '/etc/my.cnf' do
  source 'my.cnf.erb'
  cookbook_name 'flyway_percona_test'
end

directory '/tmp/db'

cookbook_file '/tmp/db/example.conf' do
  source 'example.conf'
  mode '0755'
  action :create
end

cookbook_file '/tmp/db/V0.21.0__Creation_Script.sql' do
  source 'V0.21.0__Creation_Script.sql'
  mode '0755'
  sensitive true
  action :create
end

flywaydb 'actaspire-db' do
  action :install
end

connector_src = "#{Chef::Config[:file_cache_path]}/mysql-connector-java-5.1.38.tar.gz"

remote_file connector_src do
  source 'https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz'
  owner 'flyway'
  group 'flyway'
  mode '0755'
  action :create
end

execute "tar xzf #{connector_src} -C /opt/flyway/drivers --strip 1"

flywaydb 'actaspire-db' do
  params(
    password: 'r00t',
    url: 'jdbc:mysql://127.0.0.1:3306/mysql',
    schemas: 'example',
    user: 'root',
    locations: 'filesystem:/tmp/db',
    cleanDisabled: true
  )
  flyway_conf '/tmp/db/example.conf'
  sensitive true
end
