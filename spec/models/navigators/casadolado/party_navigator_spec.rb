describe Casadolado::PartyNavigator do

  before :each do
    @page = mock
    @nav = Casadolado::PartyNavigator.new @page
  end

  it 'should find the party name' do
    element = mock
    element.stub!(:text).and_return ' Indie me up '
    @page.stub!(:search).with('div#texto > h1').and_return [element]

    @nav.find_name.should be_eql 'Indie me up'
  end

  it 'should know the url to the party' do
    @page.stub!(:uri).and_return 'www.casadolado.com/indiemeup.htm'
    @nav.url.should be_eql 'www.casadolado.com/indiemeup.htm'
  end

  context 'when navigating to discount list' do

    it 'should give me nothing back when there is no list' do
      @page.stub!(:iframe_with).with(:src => /form-(.*).htm/).and_return nil
      @nav.navigate_to_list.should be_nil
    end

    it 'should create a list navigator' do
      list_page = mock
      iframe = mock
      @page.stub!(:iframe_with).with(:src => /form-(.*).htm/).and_return iframe
      iframe.stub!(:uri).and_return 'form-indiemeup.htm'
      Casadolado.stub!(:get).with('form-indiemeup.htm').and_return list_page
      Casadolado::DiscountListNavigator.should_receive(:new).with(list_page)

      @nav.navigate_to_list
    end

  end

end
