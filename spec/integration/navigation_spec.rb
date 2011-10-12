require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Cabaret' do

  before :each do
    prevent_form_submission
  end

  it 'should reflect the web site structure' do
    cabaret = Nightclub.new(Cabaret::Navigator.new)
    cabaret.parties.each do |p|
      response = p.add_to_list sabella

      response.code.should be 200
      response.message.should be_eql 'ok'
    end
  end

  def prevent_form_submission
    page = mock
    body = mock
    agent = Mechanize.new

    agent.stub!(:submit).and_return page
    page.stub!(:code).and_return 200
    page.stub!(:search).and_return [body]
    body.stub!(:text).and_return 'ok'
    Mechanize.stub!(:new).and_return agent
  end

  def sabella
    Nightclubber.new 'Filipe Sabella', 'sabella@gmail.com', ['Marano', 'Pedro']
  end
end

