task :wakeup => :environment do
  HTTParty.get("http://#{ENV['URL']}/")
end

