require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Subscriber' do

  before :each do
    @subscriber = Subscriber.new fake_reporter
  end

  it 'should save a nightclubber for eternal subscription' do
    sabella = mock
    sabella.should_receive :save

    @subscriber.add sabella
  end

  it 'should subscribe a nightclubber to the available discount lists' do
    sabella = mock
    cabaret = mock
    amnesia = mock

    cabaret.stub!(:parties).and_return [amnesia]
    amnesia.should_receive(:add_to_list).with sabella

    @subscriber.add_nightclub cabaret
    @subscriber.subscribe sabella
  end

  it 'should subscribe all nightclubbers to the available discount lists' do
    marano = mock
    sabella = mock
    cabaret = mock
    amnesia = mock

    Nightclubber.stub!(:all).and_return [marano, sabella]
    cabaret.stub!(:parties).and_return [amnesia]
    amnesia.should_receive(:add_to_list).once.with marano
    amnesia.should_receive(:add_to_list).once.with sabella

    @subscriber.add_nightclub cabaret
    @subscriber.subscribe_everybody
  end

  it 'should show me the reports for the last subscriptions' do
    @subscriber.reports.should be_eql ['something happened on Monday.']
  end

  def fake_reporter
    reporter = mock
    reporter.stub!(:save)
    reporter.stub!(:clean)
    reporter.stub!(:reports).and_return ['something happened on Monday.']
    reporter
  end

end

