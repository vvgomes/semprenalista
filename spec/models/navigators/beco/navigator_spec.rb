require File.expand_path(File.dirname(__FILE__) + '/../../../../app/models/navigators/beco')

describe 'Beco::Navigator' do

  it 'should navigate to parties' do
    agent = mock
    page = mock
    party_link = mock
    party_page = mock

    Mechanize.stub!(:new).and_return agent
    agent.stub!(:get).with('http://www.beco203.com.br/capa-beco.php').and_return page

    page.stub!(:links_with).with(:href => /agenda-beco.php\?c=/i).and_return [party_link]
    party_link.stub!(:href).and_return 'http://url.com'
    party_link.stub!(:click).and_return [party_page]

    nav = Beco::Navigator.new
    nav.navigate_to_parties.first.should be_an_instance_of Beco::PartyNavigator
  end

end

