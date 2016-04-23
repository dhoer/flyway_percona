include_recipe 'flyway_percona::install_yum_key'
include_recipe 'percona::package_repo'

# install packages
case node['platform_family']
when 'debian'
  package 'percona-xtradb-cluster-server-5.6' do
    options '--force-yes'
  end
when 'rhel'
  package 'mysql-libs' do
    action :remove
  end

  package 'Percona-XtraDB-Cluster-server'
end

include_recipe 'percona::configure_server'

# access grants
include_recipe 'percona::access_grants'
