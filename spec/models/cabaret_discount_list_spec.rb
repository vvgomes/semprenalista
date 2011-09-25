require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::DiscountList' do

  before :each do
    @page = mock
    agent = mock
    agent.stub!(:get).and_return @page
    Mechanize.stub!(:new).and_return agent
  end

  it 'should not be a nice discount list when there is no form' do
    @page.should_receive(:form_with).with(:action => /cadastra.php/i).and_return nil
    amnesia_list = Cabaret::DiscountList.new 'lista-amnesia.htm'
    amnesia_list.should_not be_nice
  end

  it 'should be a nice discount list when it has a regular form' do
    @page.should_receive(:form_with).with(:action => /cadastra.php/i).and_return mock
    amnesia_list = Cabaret::DiscountList.new 'lista-amnesia.htm'
    amnesia_list.should be_nice
  end

  it 'should add a nightclubber to the list' do
    friend_field = mock
    friend_field.should_receive(:value=).with 'Marano'

    form = mock
    form.should_receive(:[]=).once.with :name,'Filipe Sabella'
    form.should_receive(:[]=).once.with :email,'sabella@gmail.com'
    form.should_receive(:fields_with).with(:name => /amigo/).and_return [friend_field]
    @page.stub!(:form_with).and_return form

    amnesia_list = Cabaret::DiscountList.new 'lista-amnesia.htm'
    amnesia_list.add sabella
  end

  it 'should do add any nightclubber to the list when its not nice' do
    @page.stub!(:form_with).and_return nil
    amnesia_list = Cabaret::DiscountList.new 'lista-amnesia.htm'
    amnesia_list.add sabella
  end

  # TODO: response tests:
  # - 200
  # - some success message from response body
  # - failure code
  # - some failure message from response body

  def sabella
    sabella = mock
    sabella.stub!(:name).and_return 'Filipe Sabella'
    sabella.stub!(:email).and_return 'sabella@gmail.com'
    sabella.stub!(:friends).and_return ['Marano']
    sabella
  end
end

