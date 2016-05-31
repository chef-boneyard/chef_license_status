#!/opt/opscode/embedded/bin/ruby
# chef_license_status.rb

require 'chef'
require 'csv'
require 'socket'

hostname = Socket.gethostname
chef_server_url = "http://#{hostname}/"
client_name = 'pivotal'
signing_key_filename = '/etc/opscode/pivotal.pem'
rest = Chef::ServerAPI.new(chef_server_url, client_name: client_name, signing_key_filename: signing_key_filename)
license = rest.get_rest('/license')
node_count = license['node_count']

current_time = Time.new.strftime('%Y-%m-%d %I:%M%p %Z')

column_names = ['Date', 'Hostname', 'Node Count']
values = %W(#{current_time} #{hostname} #{node_count})
headers_present = false
csv_output = CSV.generate do |csv|
  unless headers_present
    csv << column_names
    headers_present = true
  end
  csv << values
end

puts csv_output
