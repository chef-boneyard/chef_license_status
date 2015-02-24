#!/opt/opscode/embedded/bin/ruby
# chef_license_status.rb

require 'chef/config'
require 'chef/rest'

chef_server_url = 'https://localhost/'
client_name = 'pivotal'
signing_key_filename = '/etc/opscode/pivotal.pem'

rest = Chef::REST.new(chef_server_url, client_name, signing_key_filename)
license = rest.get_rest('/license')
current_time = Time.new.strftime('%Y-%m-%d %I:%M%p %Z')
puts 'Chef server global node count as of '\
     "#{current_time}: #{license['node_count']}"
