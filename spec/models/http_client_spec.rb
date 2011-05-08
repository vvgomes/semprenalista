require File.expand_path(File.dirname(__FILE__) + '/../../app/models/http_client')

describe 'HttpClient' do
  
  it 'should post to a service' do
    Net::HTTP.should_receive(:post_form).and_return fake_response
    
    service = 'http://www.party.com/subscribe'
    data = {
      :name => 'Fulvio Silas',
      :email => 'fulvio@gmail.com'
    }
    client = HttpClient.new
    response = client.post service, data 
    response.code.should be_eql '200'
  end
  
  private
  
  def fake_response
    response = mock
    response.stub!(:code).and_return '200'
    response
  end
  
end