describe Cabaret::PartyNavigator do

  before :each do
    @page = mock
    @nav = Cabaret::PartyNavigator.new @page
  end

  it 'should find the party name' do
    element = mock
    element.stub!(:text).and_return ' London Calling '
    @page.stub!(:search).with('div#perfil > h2').and_return [element]

    @nav.find_name.should be_eql 'London Calling'
  end

  it 'should know the url to the party' do
    @page.stub!(:uri).and_return 'www.cabaretpoa.com/london_calling.htm'
    @nav.url.should be_eql 'www.cabaretpoa.com/london_calling.htm'
  end

  context 'when navigating to discount list' do

    it 'should give me nothing back when there is no list' do
      @page.stub!(:iframe_with).with(:id => 'fr_lista').and_return nil
      @nav.navigate_to_list.should be_nil
    end

    it 'should create a list navigator' do
      list_page = mock
      iframe = mock
      @page.stub!(:iframe_with).with(:id => 'fr_lista').and_return iframe
      iframe.stub!(:uri).and_return 'listas/lista-indiada.htm?var=0000000001'
      Cabaret.stub!(:get).with('http://www.cabaretpoa.com.br/listas/lista-indiada.htm?var=0000000001').and_return list_page
      Cabaret::DiscountListNavigator.should_receive(:new).with(list_page)

      @nav.navigate_to_list
    end

  end

end

