# Encoding: utf-8

require_relative 'spec_helper'

describe 'MySQL config parameters' do
  context mysql_config('socket') do
    its(:value) { should eq '/var/lib/mysql/mysql.sock' }
  end

  context mysql_config('port') do
    its(:value) { should eq 3306 }
  end

  describe command('mysql -u root -pr00t -vv -e "select * from example.schema_version"') do
    its(:stdout) { should_not match(/Empty set/) }
  end
end
