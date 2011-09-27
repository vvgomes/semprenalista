require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::HomePage' do

  before :each do
    page = mock
    page.stub!(:link_with).with(:href => 'agenda.htm').and_return mock

    agent = mock
    agent.stub!(:get).and_return page

    Mechanize.stub!(:new).and_return agent
  end

  it 'should give me all the parties from the agenda' do
    party = mock
    agenda = mock

    agenda.should_receive(:parties).and_return [party]
    Cabaret::Agenda.stub!(:new).and_return agenda

    home = Cabaret::HomePage.new
    home.parties.should be_eql [party]
  end

end

