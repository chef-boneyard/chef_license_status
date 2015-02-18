#!/opt/opscode/embedded/bin/ruby

require 'csv'
require 'date'
require 'json'

require 'pg'
require 'sequel'

class Secrets
  attr_reader :postgres_password, :dbhost

  def initialize
    json = File.open('/etc/opscode/private-chef-secrets.json').read
    @secrets = JSON.parse(json)
    @postgres_password = @secrets['postgresql']['sql_password']

    # should be some way to derive this.
    @dbhost = 'localhost'
  end
end

# see https://github.com/chef/opscode-platform-debug/blob/master/orgmapper/scripts/get_org_stats.rb for the
# origin of these measurements. --cdoherty
class UsageReport
  def initialize
    @secrets = Secrets.new
    @db = Sequel.postgres 'opscode_chef', { user: 'opscode_chef', password: @secrets.postgres_password,
                                            host: @secrets.dbhost, port: 5432
                                          }
  end

  def sql(days_ago = 0)
    start_date = Date.today - days_ago
    date_yesterday = (start_date - 1).to_time.to_s
    date_7days_ago = (start_date - 7).to_time.to_s

    %{
      SELECT
        (SELECT '#{start_date}' as as_of_date),
        (SELECT COUNT(1) FROM nodes) as node_count,
        (SELECT COUNT(1) FROM nodes WHERE updated_at >= '#{date_yesterday}') as node_count_since_yesterday,
        (SELECT COUNT(1) FROM nodes WHERE updated_at >= '#{date_7days_ago}') as node_count_past_7days;
      }
  end

  def run
    headers_present = false
    csv_output = CSV.generate do |csv|
      (0..30).each do |days_ago|
        results = @db[sql(days_ago)].all

        unless headers_present
          column_names = results.first.keys
          csv << column_names
          headers_present = true
        end

        results.each do |x|
          csv << x.values
        end
      end
    end

    puts csv_output
  end
end

UsageReport.new.run if $PROGRAM_NAME == __FILE__
