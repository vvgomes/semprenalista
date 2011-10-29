# load all models
Dir.glob(File.expand_path(File.dirname(__FILE__) + '/../app/models/**/*.rb')).each{|file| require file}