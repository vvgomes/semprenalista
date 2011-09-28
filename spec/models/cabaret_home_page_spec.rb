require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::HomePage' do

  it 'should give me all the parties with discount list' do
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

    agenda = mock
    amnesia = mock
    london_calling = mock
    Cabaret::Agenda.stub!(:new).with(agenda_page).and_return agenda
    agenda.should_receive(:parties).and_return [amnesia, london_calling]
    amnesia.should_receive(:nice?).and_return false
    london_calling.should_receive(:nice?).and_return true

    home = Cabaret::HomePage.new
    home.parties.should be_eql [london_calling]
  end

end

