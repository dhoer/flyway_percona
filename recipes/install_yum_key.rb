# This is a work-around to download the Percona Yum GPG package
# signing key before allowing YUM to automatically do it in order
# to get past a new (as of Apr 1, 2015), untrusted (on CentOS 6, at least)
# SSL cert on the Percona web server. Failure to do this will cause
# packages installations from the Percona yum repo to fail.
#
# NOTE: execute this recipe before running percona::package_repo

remote_file '/etc/pki/rpm-gpg/RPM-GPG-KEY-percona' do
  action :create
  source 'http://www.percona.com/downloads/RPM-GPG-KEY-percona'
  owner 'root'
  group 'root'
  mode  '0644'
  only_if { platform_family? 'rhel' }
end
