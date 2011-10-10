require File.expand_path(File.dirname(__FILE__) + '/../../../../app/models/navigators/beco')

describe 'Beco::PartyNavigator' do

  before :each do
    @page = mock
    @nav = Beco::PartyNavigator.new @page
  end

  it 'should find the party name' do
    element = mock
    element.stub!(:text).and_return ' Indie Rocker '
    @page.stub!(:search).with('div.conteudo-interna h1 strong').and_return [element]

    @nav.find_name.should be_eql 'Indie Rocker'
  end

  context 'when navigating to discount list' do

    it 'should give me nothing back when trying to navigate to the list' do
      @page.stub!(:search).with('div.conteudo-interna a.nomenalista').and_return nil
      @nav.navigate_to_list.should be_nil
    end

    it 'should navigate to the list' do
      page = mock
      link = mock
      link.stub!(:click).and_return page
      @page.stub!(:search).with('div.conteudo-interna a.nomenalista').and_return [link]
      Beco::DiscountListNavigator.should_receive(:new).with(page)

      @nav.navigate_to_list
    end

  end

end

