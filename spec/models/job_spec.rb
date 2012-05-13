describe Job do
    
  before :each do
    @job = Job.new
    @clubber = mock
    @party = mock
    Party.stub!(:all).and_return [@party]
  end
  
  context 'when finding a clubber to be subcribed' do

    before :each do
      @clubber.stub!(:remove_expired_subscriptions)
      @job.stub!(:subscribe)
    end

    it 'should find by email' do
      Nightclubber.should_receive(:where).with(:email => 'lipe@gmail.com').and_return [@clubber]
      @job.run 'lipe@gmail.com'
    end
  
    it 'should find the next elegible one' do
      Nightclubber.should_receive(:next_to_subscribe).and_return @clubber
      @job.run
    end
    
    it 'should skip when nobody is found' do
      Nightclubber.should_receive(:next_to_subscribe).and_return nil
      @job.should_receive(:log).with('Everybody is already subscribed \o/');
      @job.run
    end

  end
    
  context 'when subscribing' do
      
    before :each do
      @job.stub!(:log)
      @job.stub!(:find).and_return @clubber
      @clubber.stub!(:remove_expired_subscriptions)
      @clubber.stub!(:find_missing_from).and_return [@party]
      @clubber.stub!(:email)
      @party.stub!(:name)
      @subscription = mock
      Subscription.stub!(:new).and_return @subscription
    end
    
    it 'should add the clubber to the party list' do
      @clubber.stub!(:add)
      @clubber.stub!(:save)
      
      @party.should_receive(:add_to_list).with(@clubber).and_return mock
      @job.run
    end
    
    it 'should create a new subscription and save' do
      @party.should_receive(:add_to_list).with(@clubber).and_return mock
      
      @clubber.should_receive(:add).with(@subscription)
      @clubber.should_receive(:save)
      @job.run
    end
      
  end
  
  it 'should ask clubber to throw away all the old subscriptions' do
    @job.stub!(:find).and_return @clubber
    @job.stub!(:subscribe)
    
    @clubber.should_receive(:remove_expired_subscriptions).with [@party]
    @job.run
  end
    
end
