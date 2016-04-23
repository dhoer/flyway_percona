require 'spec_helper'

describe 'flyway_percona::server' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '6.4', log_level: :error, evaluate_guards: true) do |node|
      #      ChefSpec::Server.create_environment('testing',  description: '...')
      Chef::Config[:client_key] = '/etc/chef/client.pem'
      node.set['mysql']['client']['package'] = 'Percona-Server-client-56'
      node.set['mysql']['shared']['package'] = 'Percona-Server-shared-56'
      node.set['mysql']['server']['package'] = 'Percona-Server-server-56'
      stub_command('rpm -qa | grep Percona-Server-shared-56').and_return(false)
      stub_command('test -f /var/lib/mysql/mysql/user.frm').and_return(false)
      stub_command('test -f /etc/mysql/grants.sql').and_return(false)
    end.converge(described_recipe)
  end

  before do
    stub_command("mysqladmin --user=root --password='' version").and_return(true)
  end

  it 'installs the yum gpg key' do
    expect(chef_run).to include_recipe 'flyway_percona::install_yum_key'
    expect(chef_run).to create_remote_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-percona').with(
      source: 'http://www.percona.com/downloads/RPM-GPG-KEY-percona',
      owner: 'root',
      group: 'root',
      mode:  '0644'
    )
  end

  it 'adds the percona package repo' do
    expect(chef_run).to include_recipe 'percona::package_repo'
  end

  it 'installs mysql client' do
    expect(chef_run).to include_recipe('flyway_percona::client')
  end

  it 'installs the mysql packages' do
    expect(chef_run).to install_yum_package('Percona-Server-server-56').with(
      allow_downgrade: true
    )
  end

  it 'removes mysql-libs if a conflicting package exists' do
    stub_command('rpm -qa | grep Percona-Server-shared-56').and_return(false)
    chef_run.converge(described_recipe)
    expect(chef_run).to remove_package('mysql-libs')
  end

  it 'installs the mysql client and shared packages' do
    expect(chef_run).to install_yum_package('Percona-Server-client-56').with(
      allow_downgrade: true
    )
    expect(chef_run).to install_yum_package('Percona-Server-shared-56').with(
      allow_downgrade: true
    )
  end

  it 'installs the mysql packages with specific versions' do
    chef_run.node.override['mysql']['server']['package_version'] = 'foo5.6.15-rel63.0.519.rhel6'
    chef_run.converge(described_recipe)
    expect(chef_run).to install_yum_package('Percona-Server-server-56').with(
      allow_downgrade: true,
      version: 'foo5.6.15-rel63.0.519.rhel6'
    )
  end

  it 'configures the mysql server' do
    expect(chef_run).to include_recipe('percona::configure_server')
  end

  it 'configures the access grants' do
    expect(chef_run).to include_recipe('percona::access_grants')
  end

  it 'configure mysql replication' do
    expect(chef_run).to include_recipe('percona::replication')
  end
end
