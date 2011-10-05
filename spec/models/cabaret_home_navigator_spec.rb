require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::HomeNavigator' do

  it 'should be able to navigate to agenda' do
    agent = mock
    home_page = mock
    agenda_link = mock
    agenda_page = mock

    Mechanize.stub!(:new).and_return agent
    agent.stub!(:get).with('http://www.cabaretpoa.com.br').and_return home_page
    home_page.stub!(:link_with).with(:text => /agenda/i).and_return agenda_link
    agenda_link.stub!(:click).and_return agenda_page

    nav = Cabaret::HomeNavigator.new
    nav.navigate_to_agenda.should be_an_instance_of Cabaret::AgendaNavigator
  end

end

