require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Cabaret::Navigator do

  before :each do
    @page = mock
    Cabaret.stub!(:get).with('http://www.cabaretpoa.com.br/agenda.htm').and_return @page
    @nav = Cabaret::Navigator.new
  end

  it 'should navigate to parties' do
    party_link = mock
    @page.stub!(:links_with).with(:text => /saiba mais/i).and_return [party_link]
    party_link.stub!(:click)

    @nav.navigate_to_parties.first.should be_an_instance_of Cabaret::PartyNavigator
  end

  it 'should know the nightclub name' do
    @nav.name.should be_eql 'Cabaret'
  end

end

