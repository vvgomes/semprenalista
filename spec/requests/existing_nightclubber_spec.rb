describe 'An existing nightclubber', :type => :request, :js => true do

  before :all do
    Nightclubber.delete_all
  end

  before :each do
    Nightclubber.new('Filipe Sabella', 'lipe@gmail.com', ['Marano']).save
  end

  after :each do
    Nightclubber.delete_all
  end

  it 'should not be able to join again' do
    visit '/'
    fill_in 'name', :with => 'Filipe Sabella'
    fill_in 'email', :with => 'lipe@gmail.com'
    click_button 'submit'
    page.should have_content 'Este email já foi utilizado.'
  end

  it 'should be able to see his current info' do
    search
    find_field('name').value.should be == 'Filipe Sabella'
    find_field('email').value.should be == 'lipe@gmail.com'
    find_field('friends[0]').value.should be == 'Marano'
  end

  it 'should be able to edit his info' do
    search
    fill_in 'name', :with => 'Jose Bartiella'
    fill_in 'friends[0]', :with => 'Thiago'
    click_button 'submit'
    page.should have_content 'Inscrição alterada com sucesso.'

    search
    find_field('name').value.should be == 'Jose Bartiella'
    find_field('email').value.should be == 'lipe@gmail.com'
    find_field('friends[0]').value.should be == 'Thiago'
  end

  it 'should not be able to edit his info with invalid data' do
    search
    fill_in 'name', :with => ''
    click_button 'submit'

    search
    find_field('name').value.should be == 'Filipe Sabella'
    find_field('email').value.should be == 'lipe@gmail.com'
    find_field('friends[0]').value.should be == 'Marano'
  end

  it 'should be able to remove his subscription' do
    search
    click_button 'delete'
    click_button 'delete-yes'
    page.should have_content 'Inscrição removida com sucesso.'

    search
    page.should have_content 'Não encontrado'    
  end

  def search
    visit '/'
    click_link 'edit'
    fill_in 'search-email', :with => 'lipe@gmail.com'
    click_button 'search-button'
  end

end
