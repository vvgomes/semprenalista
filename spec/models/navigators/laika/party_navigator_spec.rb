describe Laika::PartyNavigator do

  before :each do
    @page = mock
    @nav = Laika::PartyNavigator.new @page
  end

  it 'should find the party name' do
    element = mock
    @page.stub!(:search).with('//div/div/table/tbody/tr/td/p/span').and_return [element]
    element.stub!(:text).and_return ' Grindhouse'

    @nav.find_name.should be_eql 'Grindhouse'
  end

  it 'should know the url to the party' do
    @page.stub!(:uri).and_return 'www.laika.com.br/grindhouse.html'
    @nav.url.should be_eql 'www.laika.com.br/grindhouse.html'
  end

  context 'when navigating to discount list' do

    it 'should give me nothing back when there is no list' do
      @page.stub!(:form_with).with(:action => 'index.php').and_return nil
      @nav.navigate_to_list.should be_nil
    end

    it 'should create a list navigator' do
      @page.stub!(:form_with).with(:action => 'index.php').and_return mock
      @nav.navigate_to_list.should be_an_instance_of Laika::DiscountListNavigator
    end

  end

end
