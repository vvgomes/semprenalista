describe Cabaret::Navigator do

  before :each do
    @page = mock
    Cabaret.stub!(:get).and_return @page
    @nav = Cabaret::Navigator.new
  end

  it 'should navigate to parties' do
    @page.stub!(:body).and_return 'href="amnesia.htm"'
    @nav.navigate_to_parties.first.should be_an_instance_of Cabaret::PartyNavigator
  end

  it 'should know the nightclub name' do
    @nav.name.should be_eql 'Cabaret'
  end

end

