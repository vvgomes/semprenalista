require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')
require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclubber')

describe 'Cabaret' do

  before :each do
    prevent_form_submission
  end

  it 'should reflect the actual web site structure' do
    home = Cabaret::Home.new.parties.each do |p|
      response = p.add_to_list sabella

      response.code.should be 200
      response.message.should be_eql 'ok'
    end
  end

  def prevent_form_submission
    body = mock
    body.stub!(:text).and_return 'ok'

    page = mock
    page.stub!(:search).and_return [body]
    page.stub!(:code).and_return 200

    agent = Mechanize.new
    agent.stub!(:submit).and_return page

    Mechanize.stub!(:new).and_return agent
  end

  def sabella
    Nightclubber.new 'Filipe Sabella', 'sabella@gmail.com', ['Marano', 'Pedro']
  end
end

