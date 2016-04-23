include_recipe 'flyway_percona::install_yum_key'
include_recipe 'percona::package_repo'

# install packages
case node['platform_family']
when 'debian'
  package node['mysql']['server']['package'] do
    action :install
    options '--force-yes'
  end
when 'rhel'
  # Need to remove this to avoid conflicts
  package 'mysql-libs' do
    action :remove
    not_if 'rpm -qa | grep Percona-Server-shared-56'
  end

  # we need mysqladmin
  include_recipe 'flyway_percona::client'

  yum_package node['mysql']['server']['package'] do
    allow_downgrade true
    unless node['mysql']['server']['package_version'].empty?
      version node['mysql']['server']['package_version']
    end
    action :install
  end
end

include_recipe 'percona::configure_server'

include_recipe 'percona::access_grants'

include_recipe 'percona::replication'
