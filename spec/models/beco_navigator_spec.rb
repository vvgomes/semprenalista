require File.expand_path(File.dirname(__FILE__) + '/../../app/models/beco')

describe 'Beco::Navigator' do

  before :each do
    @agent = mock
    Mechanize.stub!(:new).and_return @agent
    @nav = Beco::Navigator.new
  end

  it 'should navigate to home' do
    home = mock
    @agent.stub!(:get).with('http://www.beco203.com.br').and_return home
    @nav.navigate_to_home.should be home
  end

  it 'should navigate from home to agenda' do
    home = mock
    agenda = mock
    link = mock

    home.stub!(:link_with).with(:href => 'capa-beco.php').and_return link
    link.stub!(:click).and_return agenda

    @nav.navigate_to_agenda_from(home).should be agenda
  end


end

