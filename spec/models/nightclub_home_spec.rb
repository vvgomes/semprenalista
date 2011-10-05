require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclub')

describe 'Nightclub::Home' do

  it 'should give me all the nice parties' do
    nice = mock
    nice.stub!(:nice?).and_return true

    boring = mock
    boring.stub!(:nice?).and_return false

    nav = mock
    nav.stub!(:navigate_to_agenda).and_return mock

    agenda = mock
    Nightclub::Agenda.stub!(:new).and_return agenda
    agenda.stub!(:parties).and_return [nice, boring]

    home = Nightclub::Home.new nav
    home.parties.should be_eql [nice]
  end

end

