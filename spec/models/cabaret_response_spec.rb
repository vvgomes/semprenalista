require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::Response' do

  context 'that is empty' do

    before :each do
      @response = Cabaret::EmptyResponse.new 'Form not found!'
    end

    it 'should not be nice' do
      @response.code.should be 0
    end

    it 'should give me an emptiness message' do
      @response.message.should be_eql 'Form not found!'
    end

  end

  context 'after successful submission' do

    before :each do
      page = stubbed_page 200,
      'Nome(s) adicionado(s) a lista. Confira seu email para maiores informações. Voltar'

      @response = Cabaret::Response.new page
    end

    it 'should have a success code' do
      @response.code.should be 200
    end

    it 'should have a response message' do
      @response.message.should include 'Nome(s) adicionado(s) a lista'
    end

  end

  context 'after failed submission' do

    before :each do
      page = stubbed_page 500, 'something went wrong'
      @response = Cabaret::Response.new page
    end

    it 'should give me a boring code' do
      @response.code.should_not be 200
    end

    it 'should not be able to find the success message' do
      @response.message.should be_eql 'something went wrong'
    end

  end

  def stubbed_page code, message
    page = mock
    page.stub!(:code).and_return code

    nav = mock
    nav.stub!(:find_message_for).with(page).and_return message
    Cabaret::Navigator.stub!(:new).and_return nav

    page
  end

end

