describe Laika::DiscountListNavigator do

  before :each do
    @form = mock
    @fields = [mock, mock, mock, mock]
    @form.stub!(:fields).and_return @fields
    @nav = Laika::DiscountListNavigator.new @form
  end

  it 'should fill the name field in the form' do
    @fields[1].should_receive(:value=).with('Sabella')
    @nav.fill_name 'Sabella'
  end

  it 'should fill the email in the form' do
    @fields[0].should_receive(:value=).with('lipe@gmail.com')
    @nav.fill_email 'lipe@gmail.com'
  end

  it 'should fill the fields for friends' do
    @fields[2].should_receive(:value=).with('Marano')
    @fields[3].should_receive(:value=).with('Pedro')
    @nav.fill_friends ['Marano', 'Pedro']
  end

  it 'should submit the form and navigate to response' do
    Laika.stub(:submit).with(@form).and_return mock
    @nav.submit.should be_an_instance_of Laika::ResponseNavigator
  end

end

