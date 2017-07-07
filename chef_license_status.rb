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

# create a Time object that is 30.5 days in the past
since =  Time.now - (60 * 60 * 24 * 30.5)
checkin_since = 0
puts "***********************************************************"
puts "creating report for nodes that have checked in since #{since} \n\n"

orgs = rest.get_rest('/organizations')
orgs.each do |org|
  nodes = Hash.new
  nodes = rest.get_rest("/organizations/#{org[0]}/nodes")
  nodes.each do |node|
    object = rest.get_rest("/organizations/#{org[0]}/nodes/#{node[0]}")
    if Time.at(object['automatic']['ohai_time']) > since
      puts "organization:\ #{org[0]}\ node:\ #{object['name']}\ checked\ in:\ #{Time.at(object['automatic']['ohai_time'])}"
      checkin_since += 1
    end
  end
end
puts "********************************************************** \n\n"

current_time = Time.new.strftime('%Y-%m-%d %I:%M%p %Z')

column_names = ['Date', 'Hostname', 'Node Count', 'Checked In']
values = %W(#{current_time} #{hostname} #{node_count} #{checkin_since})
headers_present = false
csv_output = CSV.generate do |csv|
  unless headers_present
    csv << column_names
    headers_present = true
  end
  csv << values
end

puts csv_output
