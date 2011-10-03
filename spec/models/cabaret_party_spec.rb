require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')
require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclubber')

describe 'Cabaret::Party' do

  before :each do
    @page = mock
    @nav = mock
    @nav.stub!(:find_party_name_for).with(@page).and_return 'Amnesia'
    @nav.stub!(:navigate_to_list_from).with(@page).and_return nil
    Cabaret::Navigator.stub!(:new).and_return @nav
  end

  it 'should give me its name' do
    Cabaret::Party.new(@page).name.should be_eql 'Amnesia'
  end

  it 'should not be fine when there is no discount list' do
    Cabaret::Party.new(@page).should_not be_fine
  end

  it 'should not be fine when its discount list is not fine' do
    list_page = mock
    list = mock

    @nav.stub!(:navigate_to_list_from).with(@page).and_return list_page
    Cabaret::DiscountList.stub!(:new).with(list_page).and_return list
    list.stub!(:fine?).and_return false

    Cabaret::Party.new(@page).should_not be_fine
  end

  context 'that has a fine discount list' do

    before :each do
      list_page = mock
      @list = mock

      @nav.stub!(:navigate_to_list_from).with(@page).and_return list_page
      Cabaret::DiscountList.stub!(:new).with(list_page).and_return @list
      @list.stub!(:fine?).and_return true
      @list.stub!(:add).and_return mock
    end

    it 'should be fine' do
      Cabaret::Party.new(@page).should be_fine
    end

    it 'should add a nightclubber to its discount list' do
      sabella = Nightclubber.new 'Sabella', 'lipe@gmail.com', ['Marano']
      response = mock

      @list.stub!(:add).with(sabella).and_return response

      party = Cabaret::Party.new @page
      party.add_to_list(sabella).should be_eql response
    end

  end

end

