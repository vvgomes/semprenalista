require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')
require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclubber')

describe 'Cabaret::Party' do

  before :each do
    @nav = mock
    Cabaret::Navigator.stub!(:new).and_return @nav
  end

  it 'should give me its name' do
    page = mock

    @nav.stub!(:find_party_name_for).with(page).and_return 'Amnesia'
    @nav.stub!(:navigate_to_list_from).with(page).and_return mock

    amnesia = Cabaret::Party.new page
    amnesia.name.should be_eql 'Amnesia'
  end

  context 'that does not have a discount list' do

    it 'should not be a nice party when there is no discount list' do
      page = mock

      @nav.stub!(:find_party_name_for).with(page).and_return 'London Calling'
      @nav.stub!(:navigate_to_list_from).with(page).and_return nil

      london_calling = Cabaret::Party.new page
      london_calling.should_not be_nice
    end

  end

  context 'that has a discount list' do

    it 'should be nice' do
      page = mock

      @nav.stub!(:find_party_name_for).with(page).and_return 'Amnesia'
      @nav.stub!(:navigate_to_list_from).with(page).and_return mock

      amnesia = Cabaret::Party.new page
      amnesia.should be_nice
    end

    it 'should add a nightclubber to its discount list' do
      sabella = Nightclubber.new 'Sabella', 'lipe@gmail.com', ['Marano']
      page = mock
      list = mock
      response = mock

      @nav.stub!(:find_party_name_for).with(page).and_return 'Amnesia'
      @nav.stub!(:navigate_to_list_from).with(page).and_return list
      list.stub!(:add).with(sabella).and_return response
      Cabaret::DiscountList.stub!(:new).and_return list

      amnesia = Cabaret::Party.new page
      amnesia.add_to_list(sabella).should be_eql response
    end

  end

end

