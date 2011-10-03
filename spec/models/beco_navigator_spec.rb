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

  it 'should navigate from agenda to parties' do
    agenda = mock
    party = mock
    link = mock

    agenda.stub!(:links_with).with(:href => /agenda-beco.php?c=/i).and_return [link]
    link.stub!(:click).and_return party

    @nav.navigate_to_parties_from(agenda).should be_eql [party]
  end

  it 'should find the party name at the party page' do
    party = mock
    element = mock

    party.stub!(:search).with('div.conteudo-interna h1 strong').and_return [element]
    element.stub!(:text).and_return 'Indie Rockers'

    @nav.find_party_name_for(party).should be_eql 'Indie Rockers'
  end

  it 'should navigate from party to discount list' do
    party = mock
    list = mock
    link = mock

    party.stub!(:search).with('div.conteudo-interna a.nomenalista').and_return [link]
    link.stub!(:click).and_return list

    @nav.navigate_to_list_from(party).should be list
  end

  it 'should give nothing back when there is no discount list' do
    party = mock
    party.stub!(:search).with('div.conteudo-interna a.nomenalista').and_return nil

    @nav.navigate_to_list_from(party).should be_nil
  end

end

