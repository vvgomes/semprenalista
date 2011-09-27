require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::Party' do

  context 'that has a discount list' do

    before :each do
      @list_link = mock
      page = mock
      page.should_receive(:link_with).with(:text => /enviar nome para a lista/i).and_return @list_link
      @london_calling = Cabaret::Party.new page
    end

    it 'should be a nice party when there is a discount list' do
      @london_calling.should be_nice
    end

    it 'should add a nightclubber to its discount list' do
      list = mock
      sabella = mock
      expected_response = mock
      list.should_receive(:add).with(sabella).and_return expected_response

      Cabaret::DiscountList.stub!(:new).and_return list
      @list_link.stub!(:click).and_return mock

      response = @london_calling.add_to_list sabella
      response.should be_eql expected_response
    end

  end

  context 'that does not have a discount list' do

    before :each do
      page = mock
      page.should_receive(:link_with).with(:text => /enviar nome para a lista/i).and_return nil
      @london_calling = Cabaret::Party.new page
    end

    it 'should not be a nice party when there is no discount list' do
      @london_calling.should_not be_nice
    end

    it 'should not be able to add a nightclubber to the list' do
      response = @london_calling.add_to_list mock
      response.should be_an_instance_of Cabaret::EmptyResponse
    end

    it 'should set a reason when failed to add a new nightclubber' do
      Cabaret::EmptyResponse.should_receive(:new).with('There is no discount list!')
      @london_calling.add_to_list mock
    end

  end

  it 'should give me its name based on page structure' do
    title = mock
    title.stub!(:text).and_return 'LONDON CALLING'

    page = mock
    page.stub! :link_with
    page.should_receive(:search).with('div#texto > h2').and_return [title]

    london_calling = Cabaret::Party.new page
    london_calling.name.should be_eql 'LONDON CALLING'
  end

end

