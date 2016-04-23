# Data Bags

This contains data bags to use with test kitchen (https://docs.chef.io/data_bags.html).

## Prerequisites

Add ../.chef/knife.rb file with client_key and data_bag_path entry.

```
log_level :info
log_location STDOUT
node_name 'solo'
client_key File.expand_path('./solo.pem', __FILE__)
data_bag_path File.expand_path('../../data_bags', __FILE__)
```

Generate client_key with the following command:

```
ssh-keygen -f ../.chef/solo.pem
```

## Generate Data Bag

Generate encrypted_data_bag_secret using the following command:

```
openssl rand -base64 512 | tr -d '\r\n' > encrypted_data_bag_secret
```


Encrypt this data bag:

```
{
  "id": "mysql",
  "root": "r00t",
  "backup": "backup",
  "replication": "replication",
  "dba_admin": "dba_admin"
}
```

By using the following command: 

```
knife data bag create flyway mysql -z -c ../.chef/knife.rb --secret-file encrypted_data_bag_secret
```
