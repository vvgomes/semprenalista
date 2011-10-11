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

    it 'should give me nothing back when there is no list' do
      @page.stub!(:uri).and_return 'http://beco203.com.br/agenda-beco.php?c=391'
      @page.stub!(:link_with).with(:href => /agenda_nomenalista.php\?c=391/i).and_return nil
      @nav.navigate_to_list.should be_nil
    end

    it 'should create a list navigator when there is a list' do
      page = mock
      link = mock
      @page.stub!(:uri).and_return 'http://beco203.com.br/agenda-beco.php?c=391'
      @page.stub!(:link_with).with(:href => /agenda_nomenalista.php\?c=391/i).and_return link
      link.stub!(:click).and_return page
      Beco::DiscountListNavigator.should_receive(:new).with(page)

      @nav.navigate_to_list
    end

  end

end

