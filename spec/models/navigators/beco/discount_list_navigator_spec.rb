require File.expand_path(File.dirname(__FILE__) + '/../../../../app/models/navigators/beco')

describe 'Beco::DiscountListNavigator' do

  before :each do
    @form = mock
    page = mock
    page.stub!(:form_with).with(:action => 'agenda_nomenalista.php').and_return @form
    @nav = Beco::DiscountListNavigator.new page
  end

  it 'should fill the name field in the form' do
    @form.should_receive(:[]=).with('nome', 'Sabella')
    @nav.fill_name 'Sabella'
  end

  it 'should fill the email in the form' do
    @form.should_receive(:[]=).with('email', 'lipe@gmail.com')
    @nav.fill_email 'lipe@gmail.com'
  end

  it 'should fill the fields for friends' do
    field = mock
    field.should_receive(:value=).with('Marano')
    @form.stub!(:fields_with).with(:name => /nome_amigo/i).and_return [field]
    @nav.fill_friends ['Marano']
  end

  it 'should submit the form and navigate to response' do
    agent = mock
    agent.stub(:submit).with(@form).and_return mock
    Mechanize.stub!(:new).and_return agent

    @nav.submit.should be_an_instance_of Beco::ResponseNavigator
  end

end

