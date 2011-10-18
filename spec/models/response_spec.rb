require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Response do

  context 'after a successful submission' do

    before :each do
      nav = mock
      nav.stub!(:code).and_return 200
      nav.stub!(:find_message).and_return 'Successfully added to the list!'
      @response = Response.new nav
    end

    it 'should have success code' do
      @response.code.should be 200
    end

    it 'should find the success message' do
      @response.message.should be_eql 'Successfully added to the list!'
    end

  end

  context 'after a failed submission' do

    before :each do
      nav = mock
      nav.stub!(:code).and_return 500
      nav.stub!(:find_message).and_return nil
      @response = Response.new nav
    end

    it 'should have success code' do
      @response.code.should be 500
    end

    it 'should find the success message' do
      @response.message.should be_eql 'Something went wrong!'
    end

  end

end

