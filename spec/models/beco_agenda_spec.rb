require File.expand_path(File.dirname(__FILE__) + '/../../app/models/beco')

describe 'Beco::Agenda' do

  it 'should give me all the available parties' do
    nav = mock
    page = mock
    party_page = mock
    party = mock

    nav.stub!(:navigate_to_parties_from).with(page).and_return [party_page]
    Beco::Navigator.stub!(:new).and_return nav
    Beco::Party.stub!(:new).with(party_page).and_return party

    agenda = Beco::Agenda.new page
    agenda.parties.should be_eql [party]
  end

end

