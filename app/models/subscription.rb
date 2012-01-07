require 'mongoid'

class Subscription
  include Mongoid::Document

  field :time, :type => Time
  field :party_url, :type => String
  field :message, :type => String
  field :code, :type => Integer

  embedded_in :nightclubber
  
  def initialize party, response
    super(
      :time => Time.now, 
      :party_url => party.url,
      :code => response.code, 
      :message => response.message
    )
  end
  
  def to_s
    "#{formated_time} - #{nightclubber.email} in #{party_url} - #{code} - [#{message}]"
  end

  private

  def formated_time
    time.getlocal.strftime("%d/%m/%Y %I:%M%p")
  end
  
end