require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclub')

describe 'Nightclub::Agenda' do

  it 'should give me all available parties' do
    nav = mock
    nav.stub!(:navigate_to_parties).and_return [mock]

    party = mock
    Nightclub::Party.stub!(:new).and_return party

    agenda = Nightclub::Agenda.new nav
    agenda.parties.should be_eql [party]
  end

end

