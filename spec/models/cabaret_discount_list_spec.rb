require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::DiscountList' do

  context 'that does not have a form' do

    it 'should not be able to add a nightclubber to the list' do
      amnesia_list = Cabaret::DiscountList.new page_without_form
      amnesia_list.add(sabella).should be_an_instance_of Cabaret::EmptyResponse
    end

    def page_without_form
      page_with nil
    end

  end

  context 'that has a form' do

    before :each do
      agent = mock
      agent.stub!(:submit).and_return mock
      Mechanize.stub!(:new).and_return agent
    end

    it 'should fill the form with nightclubber data' do
      friend_input = mock
      friend_input.should_receive(:value=).with 'Marano'

      form = mock
      form.should_receive(:[]=).once.with 'name','Filipe Sabella'
      form.should_receive(:[]=).once.with 'email','sabella@gmail.com'
      form.should_receive(:fields_with).with(:name => /amigo/).and_return [friend_input]

      Cabaret::DiscountList.new(page_with(form)).add sabella
    end

    it 'should give a response back after adding a nightclubber' do
      amnesia_list = Cabaret::DiscountList.new(page_with(dumb_form))
      amnesia_list.add(sabella).should be_an_instance_of Cabaret::Response
    end

    def dumb_form
      friend_input = mock
      friend_input.stub!(:value=)

      form = mock
      form.stub!(:[]=)
      form.stub!(:fields_with).
      and_return [friend_input]

      form
    end

  end

  def page_with form
    page = mock
    page.should_receive(:form_with).
    with(:action => /cadastra.php/i).and_return form
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

