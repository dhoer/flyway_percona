include_recipe 'flyway_percona::install_yum_key'
include_recipe 'percona::package_repo'

case node['platform_family']
when 'debian'
  node['mysql']['client']['packages'].each do |pak|
    package pak
    options '--force-yes'
  end
when 'rhel'

  yum_package node['mysql']['shared']['package'] do
    allow_downgrade true
    unless node['mysql']['shared']['package_version'].empty?
      version node['mysql']['shared']['package_version']
    end
    action :install
    options '-y'
  end

  yum_package node['mysql']['devel']['package'] do
    allow_downgrade true
    unless node['mysql']['devel']['package_version'].empty?
      version node['mysql']['devel']['package_version']
    end
    action :install
    options '-y'
  end

  yum_package node['mysql']['client']['package'] do
    allow_downgrade true
    unless node['mysql']['client']['package_version'].empty?
      version node['mysql']['client']['package_version']
    end
    action :install
    options '-y'
  end
end
