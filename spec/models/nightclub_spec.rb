require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclub')

describe 'Nightclub' do
  
  it 'should add a nightclubber to all available party lists' do
    fulvio = mock
    fulvio.stub!(:name).and_return 'Fulvio'
    fulvio.stub!(:email).and_return 'fulvio@gmail.com'
    fulvio.stub!(:friends).and_return ['Jairo', 'Gilda']
    
    client = mock
    client.should_receive(:post).at_least(1).times
    HttpClient.stub!(:new).and_return client
    
    cabaret = Nightclub.new
    cabaret.add_to_available_lists fulvio
  end
  
end