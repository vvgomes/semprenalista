require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::Home' do

  it 'should give me all the parties with discount list' do
    nav = mock
    nav.stub!(:navigate_to_home).and_return mock
    nav.stub!(:navigate_to_agenda_from).and_return mock
    Cabaret::Navigator.stub!(:new).and_return nav

    agenda = mock
    Cabaret::Agenda.stub!(:new).and_return agenda

    amnesia = party :not_nice
    london_calling = party :nice
    agenda.stub!(:parties).and_return [amnesia, london_calling]

    home = Cabaret::Home.new
    home.parties.should be_eql [london_calling]
  end

  def party niceness
    party = mock
    party.stub!(:nice?).and_return (niceness == :nice)
    party
  end

end

