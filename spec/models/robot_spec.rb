describe Robot do

  before :each do
    subscriber = mock
    subscriber.should_receive(:subscribe_everybody)
    Rufus::Scheduler.stub!(:start_new).and_return FakeJob.new
    @robot = Robot.new subscriber
  end

  it 'should subscribe everybody every monday midday' do
    @robot.work
  end

  it 'should subscribe everybody eventually' do
    @robot.do_it_now
  end

  class FakeJob
    def cron expression, &block
      fail if expression != '0 12 * * 1'
      block.call
    end

    def in expression, &block
      fail if expression != '5s'
      block.call
    end
  end

end

