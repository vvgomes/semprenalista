require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe 'Cabaret::ResponseNavigator' do

  it 'should find the response code' do
    page = mock
    page.stub!(:code).and_return 200
    nav = Cabaret::ResponseNavigator.new page
    nav.code.should be 200
  end

  it 'should find the confirmation message' do
    element = mock
    element.stub!(:text).and_return ' message '
    page = mock
    page.stub!(:search).with('body').and_return [element]
    nav = Cabaret::ResponseNavigator.new page
    nav.find_message.should be_eql 'message'
  end

end

