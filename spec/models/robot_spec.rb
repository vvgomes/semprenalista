require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Robot' do

  it 'should subscribe everybody every monday midday' do
    Rufus::Scheduler.stub!(:start_new).and_return FakeJob.new

    subscriber = mock
    subscriber.should_receive(:subscribe_everybody)

    robot = Robot.new subscriber
    robot.work
  end

  class FakeJob
    def cron expression, &block
      fail if expression != '0 12 * * 1'
      block.call
    end
  end

end

