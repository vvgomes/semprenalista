require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe 'Cabaret::Navigator' do

  it 'should navigate to parties' do
    page = mock
    party_link = mock
    party_page = mock

    Cabaret.stub!(:get).with('http://www.cabaretpoa.com.br/agenda.htm').and_return page
    page.stub!(:links_with).with(:text => /saiba mais/i).and_return [party_link]
    party_link.stub!(:click).and_return [party_page]

    nav = Cabaret::Navigator.new
    nav.navigate_to_parties.first.should be_an_instance_of Cabaret::PartyNavigator
  end

end

