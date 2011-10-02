require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')
require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclubber')

describe 'Cabaret::DiscountList' do

  before :each do
    @nav = mock
    Cabaret::Navigator.stub!(:new).and_return @nav
  end

  context 'that does not have a form' do

    it 'should not be able to add a nightclubber to the list' do
      page = mock

      @nav.stub!(:find_form_for).with(page).and_return nil

      list = Cabaret::DiscountList.new page
      list.add(sabella).should be_an_instance_of Cabaret::EmptyResponse
    end

  end

  context 'that has a form' do

    it 'should fill the form with nightclubber data and submit' do
      page = mock
      form = mock
      field = mock
      response = mock

      @nav.stub!(:find_form_for).with(page).and_return form
      @nav.stub!(:friend_fields_for).with(form).and_return [field]
      @nav.stub!(:submit).with(form).and_return mock
      Cabaret::Response.stub!(:new).and_return response

      form.should_receive(:[]=).once.with 'name','Sabella'
      form.should_receive(:[]=).once.with 'email','lipe@gmail.com'
      field.should_receive(:value=).with 'Marano'

      list = Cabaret::DiscountList.new page
      list.add(sabella).should be response
    end

  end

  def sabella
    Nightclubber.new 'Sabella', 'lipe@gmail.com', ['Marano']
  end

end

