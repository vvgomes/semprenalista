task :wakeup => :environment do
  HTTParty.get(ENV['URL'])
end

