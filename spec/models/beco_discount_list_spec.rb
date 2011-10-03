require File.expand_path(File.dirname(__FILE__) + '/../../app/models/beco')
require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclubber')

describe 'Beco::DiscountList' do

  before :each do
    @nav = mock
    Beco::Navigator.stub!(:new).and_return @nav
  end

  context 'that does not have a form' do

    xit 'should not be fine' do
      page = mock

      @nav.stub!(:find_form_for).with(page).and_return nil

      list = Beco::DiscountList.new page
      list.add(sabella).should be_an_instance_of Beco::EmptyResponse
    end

  end

  context 'that has a form' do

    xit 'should fill the form with nightclubber data and submit' do
      page = mock
      form = mock
      field = mock
      response = mock

      @nav.stub!(:find_form_for).with(page).and_return form
      @nav.stub!(:find_friend_fields_for).with(form).and_return [field]
      @nav.stub!(:submit).with(form).and_return mock
      Beco::Response.stub!(:new).and_return response

      form.should_receive(:[]=).once.with 'name','Sabella'
      form.should_receive(:[]=).once.with 'email','lipe@gmail.com'
      field.should_receive(:value=).with 'Marano'

      list = Beco::DiscountList.new page
      list.add(sabella).should be response
    end

  end

  def sabella
    Nightclubber.new 'Sabella', 'lipe@gmail.com', ['Marano']
  end

end

