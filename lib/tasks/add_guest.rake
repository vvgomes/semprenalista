namespace :add_guest do
  [:beco, :cucko, :lab].each do |name| 
    task name => :environment do
      AddGuestJob.new(Club.find_by(:name => name)).run
    end
  end
end

