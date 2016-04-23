require 'spec_helper'

describe 'flyway_percona::client' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'centos', version: '6.4', log_level: :error, evaluate_guards: true) do |node|
      #      ChefSpec::Server.create_environment('testing',  description: '...')
      Chef::Config[:client_key] = '/etc/chef/client.pem'
      node.set['mysql']['client']['package'] = 'Percona-Server-client-56'
      node.set['mysql']['shared']['package'] = 'Percona-Server-shared-56'
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

  it 'installs the mysql packages' do
    expect(chef_run).to install_yum_package('Percona-Server-client-56').with(
      allow_downgrade: true
    )
    expect(chef_run).to install_yum_package('Percona-Server-shared-56').with(
      allow_downgrade: true
    )
    expect(chef_run).to install_yum_package('Percona-Server-devel-56').with(
      allow_downgrade: true
    )
  end

  it 'installs the mysql packages with specific versions' do
    chef_run.node.override['mysql']['shared']['package_version'] = 'bar5.6.15-rel63.0.519.rhel6'
    chef_run.node.override['mysql']['client']['package_version'] = 'foo5.6.15-rel63.0.519.rhel6'
    chef_run.converge(described_recipe)
    expect(chef_run).to install_yum_package('Percona-Server-client-56').with(
      allow_downgrade: true,
      version: 'foo5.6.15-rel63.0.519.rhel6'
    )
    expect(chef_run).to install_yum_package('Percona-Server-shared-56').with(
      allow_downgrade: true,
      version: 'bar5.6.15-rel63.0.519.rhel6'
    )
  end
end
