require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::HomePage' do

  it 'should give me all the parties from the agenda' do
    agent = mock
    page = mock
    agenda_link = mock
    agenda_page = mock

    page.stub!(:link_with).
    with(:href => 'agenda.htm').
    and_return agenda_link

    agenda_link.stub!(:click).
    and_return agenda_page

    agent.stub!(:get).and_return page
    Mechanize.stub!(:new).and_return agent

    party = mock
    agenda = mock
    Cabaret::Agenda.stub!(:new).with(agenda_page).and_return agenda
    agenda.should_receive(:parties).and_return [party]

    home = Cabaret::HomePage.new
    home.parties.should be_eql [party]
  end

end

