require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::Agenda' do

  it 'should give me all the available parties' do
    amnesia = mock
    Cabaret::Party.stub!(:new).and_return amnesia

    agenda = Cabaret::Agenda.new agenda_page
    agenda.parties.should be_eql [amnesia]
  end

  def agenda_page
    link = mock
    link.stub!(:click).and_return mock

    page = mock
    page.stub!(:links_with).with(:text => /saiba mais/i).and_return [link]
    page
  end

end

