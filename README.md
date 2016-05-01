# Flyway Percona 
 
[![Build Status](http://img.shields.io/travis/dhoer/flyway_percona.svg?style=flat-square)][travis]

[travis]: https://travis-ci.org/dhoer/flyway_percona

The intention of this repo is to demonstrate an incompatibility with Flyway 4.0 against a percona mysql database.  Specifically, the flyway metadata table (the default `schema_version` or a configured one), is created, but not populated after a successful migration.

The incompatibility is demonstrated by creating a Vagrant VM using Test Kitchen (installing percona and flyway, and executing flyway), and testing the results of the schema created with flyway.  As of this writing, a test is failing because `schema_version` is empty after migration using flyway 4.0.

### TravisCI

https://travis-ci.org/dhoer/flyway_percona/builds

### Local testing

#### Prerequisites
ChefDK, Vagrant and VirtualBox should be installed.

#### Building the VM/Manual exploration

1.  `kitchen converge default-centos-67`
2.  `kitchen login default-centos-67`
3.  `mysql -u root -pr00t -vv -e "select * from example.schema_version"`
4.  Note that the table is empty.

#### Local execution of kitchen tests

* `kitchen test default-centos-67`
* `kitchen login default-centos-67` for manual exploration
