task :wakeup => :environment do
  Rails.logger.info('WAKEUP!')
  HTTParty.get("http://#{ENV['URL']}/")
end

