# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
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

env :PATH, ENV['PATH']
set :job_template, "zsh -l -c ':job'"
set :output, 'log/cron.log'

every 14.minutes do
  runner "News::Page.new.batch"
end

every 12.hours do
  rake "sitemap:refresh:no_ping"
end

every 3.minutes do
  runner "LatestPrice.new.update_top"
end

every 5.minutes do
  runner "LatestPrice.new.low_price"
end


