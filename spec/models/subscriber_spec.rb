require File.expand_path(File.dirname(__FILE__) + '/../../app/models/subscriber')

describe 'Subscriber' do
  
  it 'should subscribe a nightclubber to the available lists' do
    fulvio = mock
    cabaret = mock
    cabaret.should_receive(:add_to_available_lists).once.with fulvio
    
    subscriber = Subscriber.new
    subscriber.add_nightclub cabaret
    subscriber.subscribe fulvio
  end
  
  it 'should add a nightclubber to the subscription list' do
    fulvio = mock
    fulvio.should_receive :save
    
    subscriber = Subscriber.new
    subscriber.add fulvio
  end
  
  it 'should subscribe all nightclubbers to the available lists' do
    marano = mock
    sabella = mock
    Nightclubber.stub!(:all).and_return [marano, sabella]
    
    cabaret = mock
    cabaret.should_receive(:add_to_available_lists).once.with marano
    cabaret.should_receive(:add_to_available_lists).once.with sabella 
    
    subscriber = Subscriber.new
    subscriber.add_nightclub cabaret
    subscriber.subscribe_everybody
  end
  
end