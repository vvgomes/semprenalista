describe Laika::DiscountListNavigator do

  before :each do
    @form = mock
    @nav = Laika::DiscountListNavigator.new @form
  end

  it 'should fill the name field in the form' do
    field = mock
    field.stub!(:name).and_return mock
    @form.stub!(:delete_field!)
    @form.stub!(:first).and_return field
    
    @form.should_receive(:first=).with('Sabella')
    @nav.fill_name 'Sabella'
  end

  it 'should fill the email in the form' do
    field = mock
    field.stub!(:name).and_return mock
    @form.stub!(:delete_field!)
    @form.stub!(:first).and_return field
    
    @form.stub!(:first=).with('lipe@gmail.com')
    @nav.fill_email 'lipe@gmail.com'
  end

  it 'should fill the fields for friends' do
    field = mock
    @form.stub!(:fields).and_return [field]
    
    field.should_receive(:value=).with('Marano')
    @nav.fill_friends ['Marano']
  end

  it 'should submit the form and navigate to response' do
    Laika.stub(:submit).with(@form).and_return mock
    @nav.submit.should be_an_instance_of Laika::ResponseNavigator
  end

end

