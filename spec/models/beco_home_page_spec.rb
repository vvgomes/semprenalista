require File.expand_path(File.dirname(__FILE__) + '/../../app/models/beco')

describe 'Beco::HomePage' do

  it 'should give me all the parties with discount list' do
    nav = mock
    nav.stub!(:navigate_to_home).and_return mock
    nav.stub!(:navigate_to_agenda_from).and_return mock
    Beco::Navigator.stub!(:new).and_return nav

    agenda = mock
    Beco::Agenda.stub!(:new).and_return agenda

    indierockers = party :not_nice
    lustforlife = party :nice
    agenda.stub!(:parties).and_return [indierockers, lustforlife]

    home = Beco::Home.new
    home.parties.should be_eql [lustforlife]
  end

  def party niceness
    party = mock
    party.stub!(:nice?).and_return (niceness == :nice)
    party
  end

end

