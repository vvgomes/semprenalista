require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclub')
require 'yaml'

describe 'Nightclub' do
  
  it 'should add a nightclubber to all available party lists' do
    friend_field = mock
    friend_field.should_receive(:value=).with 'Jairo'
    
    form = mock
    form.should_receive(:[]=).
      once.with 'name', 'Fulvio'
      
    form.should_receive(:[]=).
      once.with 'email', 'fulvio@gmail.com'
        
    form.should_receive(:fields_with).
      once.with(:name => /friend/).
      and_return [friend_field]
    
    list_link = mock
    list_link.stub! :click
    list_link.stub! :href
    
    page = mock
    page.should_receive(:links_with).
      with(:href => /list/).
      and_return [list_link]

    page.should_receive(:form_with).
      once.with(:action => 'www.party.com/list').
      and_return form
    
    response = mock
    response.stub!(:code).and_return 200
    
    agent = mock
    agent.should_receive(:get).with 'www.party.com'
    agent.stub!(:page).and_return page
    agent.should_receive(:submit).with(form).
      and_return response
    
    Mechanize.stub!(:new).and_return agent
    
    party_place = Nightclub.new config
    party_place.turn_logger_off
    party_place.add_to_available_lists nightclubber
  end
  
  private
  
  def config
    {
      :home_page => 'www.party.com',
      :service => 'www.party.com/list',
      :links => /list/,
      :param_names => {
        :friends => /friend/,
        :name => 'name',
        :email => 'email'
      }
    }
  end
  
  def nightclubber
    fulvio = mock
    fulvio.stub!(:name).and_return 'Fulvio'
    fulvio.stub!(:email).and_return 'fulvio@gmail.com'
    fulvio.stub!(:friends).and_return ['Jairo']
    fulvio
  end
  
end