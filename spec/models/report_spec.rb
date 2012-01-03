describe Report do

  before :each do
    @moment = Time.now
    Time.stub!(:now).and_return @moment
    @report = Report.new 'Cabaret', 'Amnesia', 'lipe@gmail.com', 200, 'ok'
  end

  it 'should have the nightclub name' do
    @report.club.should be_eql 'Cabaret'
  end

  it 'should have the party name' do
    @report.party.should be_eql 'Amnesia'
  end

  it 'should have the nightclubber email' do
    @report.email.should be_eql 'lipe@gmail.com'
  end

  it 'should have the response code' do
    @report.code.should be 200
  end

  it 'should have the response message' do
    @report.message.should be_eql 'ok'
  end

  it 'should know when it happened' do
    #mongoid is changing timezone
    @report.time.to_i.should be_eql @moment.to_i
  end

  it 'should be able to give me a human-readable respresentation' do
    @report.to_s.should match(
      /\d\d\/\d\d\/\d\d\d\d \d\d:\d\d[AP]M - lipe@gmail.com - Cabaret - Amnesia - 200 - \[ok\]/)
  end

end

