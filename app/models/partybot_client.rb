class PartybotClient
  include HTTParty

  def initialize(partybot_server)
    agent.base_uri(partybot_server)
  end

  def parties(filters={})
    res = agent.get('/parties', filters)
    res.parsed_response
  end

  def subscribe(user, parties)
    payload = { :user => user, :parties => parties }
    res = agent.post('/subscriptions', payload)
    res.parsed_response
  end

  private
  def agent
    self.class
  end
end
