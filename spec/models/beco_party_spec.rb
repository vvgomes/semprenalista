require File.expand_path(File.dirname(__FILE__) + '/../../app/models/beco')
require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclubber')

describe 'Beco::Party' do

  before :each do
    @page = mock
    @nav = mock
    @nav.stub!(:find_party_name_for).with(@page).and_return 'Indie Rockers'
    @nav.stub!(:navigate_to_list_from).with(@page).and_return nil
    Beco::Navigator.stub!(:new).and_return @nav
  end

  it 'should give me its name' do
    Beco::Party.new(@page).name.should be_eql 'Indie Rockers'
  end

  it 'should not be fine when there is no discount list' do
    Beco::Party.new(@page).should_not be_fine
  end

  it 'should not be fine when its discount list is not fine' do
    list_page = mock
    list = mock

    @nav.stub!(:navigate_to_list_from).with(@page).and_return list_page
    Beco::DiscountList.stub!(:new).with(list_page).and_return list
    list.stub!(:fine?).and_return false

    Beco::Party.new(@page).should_not be_fine
  end

  context 'that has a fine discount list' do

    before :each do
      list_page = mock
      @list = mock

      @nav.stub!(:navigate_to_list_from).with(@page).and_return list_page
      Beco::DiscountList.stub!(:new).with(list_page).and_return @list
      @list.stub!(:fine?).and_return true
      @list.stub!(:add).and_return mock
    end

    it 'should be fine' do
      Beco::Party.new(@page).should be_fine
    end

    it 'should add a nightclubber to the discount list' do
      sabella = Nightclubber.new 'Sabella', 'lipe@gmail.com', ['Marano']
      response = mock

      @list.stub!(:add).with(sabella).and_return response

      party = Beco::Party.new @page
      party.add_to_list(sabella).should be_eql response
    end

  end
end

