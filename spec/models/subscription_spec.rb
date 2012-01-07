describe Subscription do

  before :each do
    @moment = Time.now
    Time.stub!(:now).and_return @moment
    
    clubber = mock
    clubber.stub!(:email).and_return 'lipe@gmail.com'
    
    party = mock
    party.stub!(:url).and_return 'http://www.cabaretpoa.com.br/rocket.htm'
    
    response = mock
    response.stub!(:code).and_return 200
    response.stub!(:message).and_return 'ok'
    
    @subscription = Subscription.new party, response
    @subscription.nightclubber = Nightclubber.new '', 'lipe@gmail.com', []
  end

  it 'should know the party url' do
    @subscription.party_url.should be == 'http://www.cabaretpoa.com.br/rocket.htm'
  end

  it 'should know the nightclubber email' do
    @subscription.nightclubber.email.should be == 'lipe@gmail.com'
  end

  it 'should know the response code' do
    @subscription.code.should be 200
  end

  it 'should know the response message' do
    @subscription.message.should be == 'ok'
  end

  it 'should know when it happened' do
    #mongoid is changing timezone
    @subscription.time.to_i.should be == @moment.to_i
  end

  it 'should be able to give me a human-readable respresentation' do
    @subscription.to_s.should match(
    /\d\d\/\d\d\/\d\d\d\d \d\d:\d\d[AP]M - lipe@gmail.com in http:\/\/www.cabaretpoa.com.br\/rocket.htm - 200 - \[ok\]/)
  end
  
end

