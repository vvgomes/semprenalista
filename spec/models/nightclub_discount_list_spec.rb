require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')
require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclubber')

describe 'Nightclub::DiscountList' do

  it 'should get a response back after submiting nightclubber info' do
    sabella = Nightclubber.new('Sabella', 'lipe@gmail.com', ['Marano'])

    nav = mock
    response_nav = mock
    response = mock

    nav.stub!(:fill_name).with('Sabella')
    nav.stub!(:fill_email).with('lipe@gmail.com')
    nav.stub!(:fill_friends).with(['Marano'])
    nav.stub!(:submit).and_return response_nav
    Nightclub::Response.stub(:new).with(response_nav).and_return response

    list = Nightclub::DiscountList.new nav
    list.add(sabella).should be response
  end

end

