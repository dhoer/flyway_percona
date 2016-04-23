log_level :info
log_location STDOUT
node_name 'solo'
client_key File.expand_path('../solo.pem', __FILE__)
data_bag_path File.expand_path('../../data_bags', __FILE__)
