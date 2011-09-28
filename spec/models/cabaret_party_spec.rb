require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::Party' do

  context 'that has a discount list' do

    before :each do
      @list_link = mock
      page = mock

      page.stub!(:link_with).
      with(:text => /enviar nome para a lista/i).
      and_return @list_link

      @london_calling = Cabaret::Party.new page
    end

    it 'should be a nice party when there is a discount list' do
      @london_calling.should be_nice
    end

    it 'should add a nightclubber to its discount list' do
      london_calling_list = mock
      london_calling_list_page = mock
      response = mock
      sabella = mock

      @list_link.stub!(:click).
      and_return london_calling_list_page

      london_calling_list.should_receive(:add).
      with(sabella).and_return response

      Cabaret::DiscountList.should_receive(:new).
      with(london_calling_list_page).
      and_return london_calling_list

      @london_calling.add_to_list(sabella).should be_eql response
    end

  end

  context 'that does not have a discount list' do

    before :each do
      page = mock

      page.should_receive(:link_with).
      with(:text => /enviar nome para a lista/i).
      and_return nil

      @london_calling = Cabaret::Party.new page
    end

    it 'should not be a nice party when there is no discount list' do
      @london_calling.should_not be_nice
    end

  end

  it 'should give me its name based on page structure' do
    title = mock
    page = mock

    title.stub!(:text).and_return 'LONDON CALLING'
    page.stub!(:link_with)

    page.should_receive(:search).
    with('div#texto > h2').and_return [title]

    london_calling = Cabaret::Party.new page
    london_calling.name.should be_eql 'LONDON CALLING'
  end

end

