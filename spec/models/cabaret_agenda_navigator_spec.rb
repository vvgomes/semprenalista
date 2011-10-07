require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclub/cabaret')

describe 'Cabaret::AgendaNavigator' do

  it 'should navigate to parties' do
    page = mock
    party_link = mock
    party_page = mock

    page.stub!(:links_with).with(:text => /saiba mais/i).and_return [party_link]
    party_link.stub!(:click).and_return [party_page]

    nav = Cabaret::AgendaNavigator.new page
    nav.navigate_to_parties.first.should be_an_instance_of Cabaret::PartyNavigator
  end

end

