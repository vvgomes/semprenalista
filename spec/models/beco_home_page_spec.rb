require File.expand_path(File.dirname(__FILE__) + '/../../app/models/beco')

describe 'Beco::HomePage' do

  it 'should give me the all the available parties' do
    Mechanize.stub!(:new).and_return fake_agent

    disco_rock = party :nice
    indie_stuff = party :not_nice

    agenda = mock
    agenda.stub!(:parties).and_return [disco_rock]
    Beco::Agenda.stub!(:new).and_return agenda

    home = Beco::Home.new
    home.parties.should be_eql [disco_rock]
  end

  def fake_agent
    agent = mock
    agent.stub!(:get).with('http://www.beco203.com.br/').and_return home_page
    agent
  end

  def home_page
    agenda_link = mock
    agenda_link.stub!(:click).and_return mock

    page = mock
    page.stub!(:link_with).with(:href => 'capa-beco.php').and_return agenda_link
    page
  end

  def party niceness
    party = mock
    party.stub!(:nice?).and_return (niceness == :nice)
    party
  end

end

