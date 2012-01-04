describe Laika::Navigator do

  before :each do
    @page = mock
    Beco.stub!(:get).with('index.php?option=com_content&view=category&layout=blog&id=1&Itemid=2').and_return @page

    @nav = Laika::Navigator.new
  end

  it 'should navigate to parties' do
    party_link = mock
    @page.stub!(:links_with).with(:href => /agenda-beco.php\?c=/i).and_return [party_link]
    party_link.stub!(:href).and_return 'http://url.com'
    party_link.stub!(:click)

    @nav.navigate_to_parties.first.should be_an_instance_of Laika::PartyNavigator
  end

  it 'should know the nightclub name' do
    @nav.name.should be_eql 'Laika'
  end

end

