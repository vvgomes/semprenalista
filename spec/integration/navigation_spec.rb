describe 'Navigators' do

  before :each do
    prevent_form_submission
  end

  it 'should reflect the web site structure for Cabaret' do
    browse Nightclub.new(Cabaret::Navigator.new)
  end

  it 'should reflect the web site structure for Beco' do
    browse Nightclub.new(Beco::Navigator.new)
  end
  
  it 'should reflect the web site structure for Laika' do
    browse Nightclub.new(Laika::Navigator.new)
  end
  
  it 'should reflect the web site structure for Casadolado' do
    browse Nightclub.new(Casadolado::Navigator.new)
  end

  def browse nightclub
    parties = nightclub.parties
    parties.each do |p|
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
