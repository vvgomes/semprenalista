require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::Party' do

  it 'should give me its name' do
    page = party_page 'Amnesia'
    amnesia = Cabaret::Party.new page
    amnesia.name.should be_eql 'Amnesia'
  end

  context 'that does not have a discount list' do

    it 'should not be a nice party when there is no discount list' do
      page = not_nice(party_page('London Calling'))
      london_calling = Cabaret::Party.new page
      london_calling.should_not be_nice
    end

  end

  context 'that has a discount list' do

    it 'should be nice' do
      page = party_page 'Amnesia'
      amnesia = Cabaret::Party.new page
      amnesia.should be_nice
    end

    it 'should add a nightclubber to its discount list' do
      clubber = sabella
      response = mock
      london_calling_list = mock
      london_calling_list.should_receive(:add).with(clubber).and_return response

      Cabaret::DiscountList.stub!(:new).and_return london_calling_list

      page = party_page 'Amnesia'
      amnesia = Cabaret::Party.new page
      amnesia.add_to_list(clubber).should be_eql response
    end

  end

  def party_page name
    name_element = mock
    name_element.stub(:text).and_return name

    list_link = mock
    list_link.stub!(:click).and_return mock

    page = mock
    page.stub!(:search).with('div#texto > h2').and_return [name_element]
    page.stub!(:link_with).with(:text => /enviar nome para a lista/i).and_return list_link
    page
  end

  def not_nice page
    page.stub!(:link_with).with(:text => /enviar nome para a lista/i).and_return nil
    page
  end

  def sabella
    sabella = mock
    sabella.stub!(:name).and_return 'Filipe Sabella'
    sabella.stub!(:email).and_return 'sabella@gmail.com'
    sabella.stub!(:friends).and_return ['Marano']
    sabella
  end

end

