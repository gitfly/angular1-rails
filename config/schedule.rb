# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#

set :output, "/home/deploy/baozheng/log/cron_log.log"

#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.minutes do
  rake "database:dump[minutes]"
end

every 5.minutes do
  rake "database:dump[5minutes]"
end

every 10.minutes do
  rake "database:dump[10minutes]"
end

every 1.hour do
  rake "database:dump[hour]"
end

every 1.day, at: '00:00 am' do
  rake "database:dump[day]"
end

every 1.week do
  rake "database:dump[week]"
end

every 1.month do
  rake "database:dump[month]"
end

every 1.day, :at => '00:00 am' do
  rake "report:send_email"
end


