require 'rubygems'
require 'bundler'

Bundler.require :default
Dir.glob(File.expand_path(File.dirname(__FILE__)+'/../app/models/**/*.rb')).each{|f| require f}

Mongoid.configure do |config|
  if ENV['MONGOHQ_URL']
    puts "### MONGOHQ_URL: #{ENV['MONGOHQ_URL']}"
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    uri = URI.parse(ENV['MONGOHQ_URL'])
    config.master = conn.db(uri.path.gsub(/^\//, ''))
    puts "### uri.path.gsub:#{uri.path.gsub(/^\//, '')}"
  else
    begin
      config.master = Mongo::Connection.
        from_uri('mongodb://localhost:27017').
        db('semprenalista')
    rescue
      puts 'No DB.'
    end      
  end
end

#mongo flame.mongohq.com:27103/app525158 -u heroku -p <pass>