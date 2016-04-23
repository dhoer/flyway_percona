case node['platform_family']
when 'debian'
  normal['mysql']['client']['packages'] = %w(libmysqlclient-dev percona-server-client)
when 'rhel'
  normal['mysql']['client']['package'] = 'Percona-Server-client-56'
  normal['mysql']['client']['package_version'] = ''
  normal['mysql']['server']['package'] = 'Percona-Server-server-56'
  normal['mysql']['server']['package_version'] = ''
  normal['mysql']['shared']['package'] = 'Percona-Server-shared-56'
  normal['mysql']['shared']['package_version'] = ''
  normal['mysql']['devel']['package'] = 'Percona-Server-devel-56'
  normal['mysql']['devel']['package_version'] = ''
end
