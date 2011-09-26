require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::Response' do

  context 'that is empty' do

    before :each do
      @response = Cabaret::EmptyResponse.new
    end

    it 'should give me an emptiness message' do
      @response.message.should be_eql 'empty response'
    end

    it 'should give me a meaningless code' do
      @response.code.should be_eql 0
    end

  end

end

