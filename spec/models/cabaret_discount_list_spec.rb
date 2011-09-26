require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::DiscountList' do

  before :each do
    @page = mock
  end

  context 'that has a form' do

    before :each do
      @form = mock
      @page.should_receive(:form_with).with(:action => /cadastra.php/i).and_return @form
      @amnesia_list = Cabaret::DiscountList.new @page
    end

    it 'should be nice' do
      @amnesia_list.should be_nice
    end

    it 'should give a response back after adding a nightclubber' do
      agent = mock
      agent.should_receive(:submit).with(@form).and_return mock
      Mechanize.stub!(:new).and_return agent

      friend_field = mock
      friend_field.should_receive(:value=).with 'Marano'
      @form.should_receive(:[]=).once.with 'name','Filipe Sabella'
      @form.should_receive(:[]=).once.with 'email','sabella@gmail.com'
      @form.should_receive(:fields_with).with(:name => /amigo/).and_return [friend_field]
      response = @amnesia_list.add sabella
      response.should be_an_instance_of Cabaret::Response
    end

  end

  context 'that does not have a form' do

    before :each do
      @page.should_receive(:form_with).with(:action => /cadastra.php/i).and_return nil
      @amnesia_list = Cabaret::DiscountList.new @page
    end

    it 'should not be nice' do
      @amnesia_list.should_not be_nice
    end

    it 'should not be able to add a nightclubber to the list' do
      @amnesia_list.add(sabella).should be_an_instance_of Cabaret::EmptyResponse
    end

  end

  def sabella
    sabella = mock
    sabella.stub!(:name).and_return 'Filipe Sabella'
    sabella.stub!(:email).and_return 'sabella@gmail.com'
    sabella.stub!(:friends).and_return ['Marano']
    sabella
  end
end

