class Club < ActiveRecord::Base
  has_many :tickets
  
  def parties
    partybot.parties.map{ |raw| Party.new(raw) }
  end

  def add_guest(user)
    user.update_subscription(self)
    partybot.add_guest(user.to_h)
  end

  def ==(other)
    self.name == other.name
  end

  def import
  end

  private

  def partybot
    @client ||= PartybotClient.new(partybot_server)
  end

  def partybot_server
    app = ENV[name.upcase]
    "#{app}.herokuapp.com" if app
  end
end
