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
      @response.body.should be_eql 'Form not found!'
    end

  end

  context 'after successful submission' do

    before :each do
      page = response_page_with 200,
        'Nome(s) adicionado(s) a lista. Confira seu email para maiores informações. Voltar'
      @response = Cabaret::Response.new page
    end

    it 'should give me a success code' do
      @response.code.should be 200
    end

    it 'should extract the confirmation message from the page' do
      @response.body.should include 'Nome(s) adicionado(s) a lista'
    end

  end

  context 'after failed submission' do

    before :each do
      page = response_page_with 500, 'something went wrong'
      @response = Cabaret::Response.new page
    end

    it 'should give me a boring code' do
      @response.code.should_not be 200
    end

    it 'should not be able to find the success message' do
      @response.body.should be_eql 'something went wrong'
    end

  end

  def response_page_with code, text
    body = mock
    page = mock
    page.stub!(:code).and_return code
    page.stub!(:search).with('body').and_return [body]
    body.stub!(:text).and_return text
    page
  end

end

