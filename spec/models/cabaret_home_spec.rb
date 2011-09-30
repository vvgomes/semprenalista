require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::Home' do

  it 'should give me all the parties with discount list' do
    Mechanize.stub!(:new).and_return fake_agent

    amnesia = party :not_nice
    london_calling = party :nice

    agenda = mock
    agenda.should_receive(:parties).and_return [amnesia, london_calling]
    Cabaret::Agenda.stub!(:new).and_return agenda

    home = Cabaret::Home.new
    home.parties.should be_eql [london_calling]
  end

  def fake_agent
    agent = mock
    agent.stub!(:get).with('http://www.cabaretpoa.com.br/').and_return home_page
    agent
  end

  def home_page
    agenda_link = mock
    agenda_link.stub!(:click).and_return mock

    page = mock
    page.stub!(:link_with).with(:href => 'agenda.htm').and_return agenda_link
    page
  end

  def party niceness
    party = mock
    party.stub!(:nice?).and_return (niceness == :nice)
    party
  end

end

