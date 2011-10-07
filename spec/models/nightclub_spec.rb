require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclub')

describe 'Nightclub' do

  before :each do
    nav = mock
    party_nav = mock
    @party = mock

    nav.stub!(:navigate_to_parties).and_return [party_nav]
    Party.stub!(:new).with(party_nav).and_return @party

    @place = Nightclub.new nav
  end

  it 'should give me all the nice parties' do
    @party.stub!(:nice?).and_return true
    @place.parties.should be_eql [@party]
  end

  it 'should not give me back a not nice party' do
    @party.stub!(:nice?).and_return false
    @place.parties.should be_empty
  end

end

