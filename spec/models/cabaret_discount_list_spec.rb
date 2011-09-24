require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::DiscountList' do

  it 'should add nightclubber to the list' do
    sabella = mock
    sabella.stub!(:name).and_return 'Filipe Sabella'
    sabella.stub!(:email).and_return 'sabella@gmail.com'
    sabella.stub!(:friends).and_return ['Marano', 'Pedro']

    url = 'lista-amnesia.htm'
    amnesia_list = Cabaret::DiscountList.new url
    amnesia_list.add mock
  end

end

