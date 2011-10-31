describe Job do

  before :each do
    @subscriber = mock
    @job = Job.new @subscriber
  end

  context 'when being called by cron' do
    
    before :each do
      @day = mock
      Time.stub!(:now).and_return @day
    end
    
    it 'should subscribe everybody every monday' do
      @day.stub!(:wday).and_return 1
      @subscriber.should_receive :subscribe_everybody
      @job.run
    end

    it 'should not work if today is not monday' do
      [2, 3, 4, 5, 6, 7].each do |day|
        @day.stub!(:wday).and_return day
        @subscriber.should_not_receive :subscribe_everybody
        @job.run
      end  
    end
    
  end

  it 'should subscribe everybody eventually' do
    @subscriber.should_receive :subscribe_everybody
    @job.run_now
  end
  
end

