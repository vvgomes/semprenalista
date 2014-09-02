class Nightclub < ActiveRecord::Base
  def parties(filters={})
    partybot.parties(filters).map{ |raw| Party.new(raw) }
  end

  def subscribe(user, parties)
    partybot.subscribe(user.to_h, parties.map(&:public_id))
  end

  def ==(other)
    self.name == other.name
  end

  private
  def partybot
    @client ||= PartybotClient.new("#{ENV[name.upcase]}.herokuapp.com")
  end

  def partybot_uri
    app = ENV[name.upcase]
    "#{app}.herokuapp.com" if app
  end
end
