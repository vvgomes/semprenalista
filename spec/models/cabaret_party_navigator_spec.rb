require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclub/cabaret')

describe 'Cabaret::PartyNavigator' do

  before :each do
    @page = mock
    @nav = Cabaret::PartyNavigator.new @page
  end

  it 'should find the party name' do
    element = mock
    element.stub!(:text).and_return ' London Calling '
    @page.stub!(:search).with('div#texto > h2').and_return [element]

    @nav.find_name.should be_eql 'London Calling'
  end

  context 'when navigating to discount list' do

    it 'should give me nothing back when trying to navigate to the list' do
      @page.stub!(:link_with).with(:text => /enviar nome para a lista/i).and_return nil
      @nav.navigate_to_list.should be_nil
    end

    it 'should navigate to the list' do
      page = mock
      link = mock
      link.stub!(:click).and_return page
      @page.stub!(:link_with).with(:text => /enviar nome para a lista/i).and_return link
      Cabaret::DiscountListNavigator.should_receive(:new).with(page)

      @nav.navigate_to_list
    end

  end

end

