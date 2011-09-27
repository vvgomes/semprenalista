require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::Agenda' do

  it 'should give me the available parties' do
    agenda_page = mock
    amnesia_link = mock
    amnesia_page = mock
    amnesia = mock

    agenda_page.stub!(:links_with).
    with(:text => /saiba mais/i).
    and_return [amnesia_link]

    amnesia_link.stub!(:click).
    and_return amnesia_page

    Cabaret::Party.should_receive(:new).
    with(amnesia_page).and_return amnesia

    agenda = Cabaret::Agenda.new agenda_page
    agenda.parties.should be_eql [amnesia]
  end

end

