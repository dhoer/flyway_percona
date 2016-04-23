#
# Cookbook Name:: flyway_percona
# Recipe:: default
#
# Alias flyway_percona::default to percona::client like in mysql cookbook.
include_recipe 'flyway_percona::client'
