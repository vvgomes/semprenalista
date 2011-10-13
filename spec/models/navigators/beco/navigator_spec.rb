require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe 'Beco::Navigator' do

  before :each do
    @page = mock
    Beco.stub!(:get).with('http://www.beco203.com.br/capa-beco.php').and_return @page

    @nav = Beco::Navigator.new
  end

  it 'should navigate to parties' do
    party_link = mock
    @page.stub!(:links_with).with(:href => /agenda-beco.php\?c=/i).and_return [party_link]
    party_link.stub!(:href).and_return 'http://url.com'
    party_link.stub!(:click)

    @nav.navigate_to_parties.first.should be_an_instance_of Beco::PartyNavigator
  end

  it 'should know the nightclub name' do
    @nav.name.should be_eql 'Beco'
  end

end

