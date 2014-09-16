class PartybotClient
  include HTTParty

  def initialize(partybot_server)
    agent.base_uri(partybot_server)
  end

  def parties
    agent.get('/parties').parsed_response
  end

  def add_guest(user)
    payload = { :name => user.name, :email => user.email }
    agent.post('/guests', payload).code
  end

  private
  def agent
    self.class
  end
end
