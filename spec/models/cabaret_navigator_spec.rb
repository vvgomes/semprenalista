require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::Navigator' do

  before :each do
    @agent = mock
    Mechanize.stub!(:new).and_return @agent
    @nav = Cabaret::Navigator.new
  end

  it 'should navigate to home' do
    home = mock
    @agent.stub!(:get).with('http://www.cabaretpoa.com.br/').and_return home
    @nav.navigate_to_home.should be home
  end

  it 'should navigate from home to agenda' do
    home = mock
    agenda = mock
    link = mock

    home.stub!(:link_with).with(:href => 'agenda.htm').and_return link
    link.stub!(:click).and_return agenda

    @nav.navigate_to_agenda_from(home).should be agenda
  end

  it 'should navigate from agenda to parties' do
    agenda = mock
    party = mock
    link = mock

    agenda.stub!(:links_with).with(:text => /saiba mais/i).and_return [link]
    link.stub!(:click).and_return party

    @nav.navigate_to_parties_from(agenda).should be_eql [party]
  end

  it 'should find the party name at the party page' do
    party = mock
    h2 = mock

    party.stub!(:search).with('div#texto > h2').and_return [h2]
    h2.stub!(:text).and_return 'Amnesia'

    @nav.find_party_name_for(party).should be_eql 'Amnesia'
  end

  it 'should navigate from party to discount list' do
    party = mock
    list = mock
    link = mock

    party.stub!(:link_with).with(:text => /enviar nome para a lista/i).and_return link
    link.stub!(:click).and_return list

    @nav.navigate_to_list_from(party).should be list
  end

  it 'should give nothing back when there is no discount list' do
    party = mock
    party.stub!(:link_with).with(:text => /enviar nome para a lista/i).and_return nil

    @nav.navigate_to_list_from(party).should be_nil
  end

  it 'should find the form in the discount list page' do
    list = mock
    form = mock

    list.stub!(:form_with).with(:action => /cadastra.php/i).and_return form

    @nav.find_form_for(list).should be form
  end

  it 'should submit the form' do
    form = mock
    response = mock

    @agent.stub!(:submit).with(form).and_return response

    @nav.submit form
  end

  it 'should find the result message in the response page' do
    response = mock
    thing = mock

    response.stub!(:search).with('body').and_return [thing]
    thing.stub!(:text).and_return 'Nome adicionados na lista!'

    @nav.find_message_for(response).should be_eql 'Nome adicionados na lista!'
  end

  it 'should find the fields for friends in the form' do
    form = mock
    field = mock
    form.stub!(:fields_with).with(:name => /amigo/).and_return [field]

    @nav.find_friend_fields_for(form).should be_eql [field]
  end

end

