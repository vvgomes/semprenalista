require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::Agenda' do

  it 'should give me all the available parties' do
    nav = mock
    page = mock
    party_page = mock
    amnesia = mock

    nav.stub!(:navigate_to_parties_from).with(page).and_return [party_page]
    Cabaret::Navigator.stub!(:new).and_return nav
    Cabaret::Party.stub!(:new).with(party_page).and_return amnesia

    agenda = Cabaret::Agenda.new page
    agenda.parties.should be_eql [amnesia]
  end

end

