describe 'An existing nightclubber', :type => :request, :js => true do

  before :all do
    Nightclubber.delete_all
  end
    
  before do
    Nightclubber.new('Filipe Sabella', 'lipe@gmail.com', ['Marano', 'Pedro']).save
    visit '/'
    click_link 'edit'
    sleep 1
    within('#overlay') do
      fill_in 'search', :with => 'lipe@gmail.com'
      click_button 'OK'
    end
  end
  
  it 'should see his current information' do
    find_field('name').value.should be == 'Filipe Sabella'
    find_field('email').value.should be == 'lipe@gmail.com'
    find_field('friends[0]').value.should be == 'Marano'
    find_field('friends[1]').value.should be == 'Pedro'
  end

  context 'after editing his information with valid data' do
    before do
      fill_in 'name', :with => 'Jose Bartiella'
      fill_in 'friends[0]', :with => 'Thiago'
      fill_in 'friends[1]', :with => 'Nascimento'
      click_button 'OK'
    end
    
    it 'should be redirected to /done' do
      page.current_url.should =~ /done/
    end

    it 'should see his new name and new friends listed at /nightclubbers' do
      visit '/nightclubbers'
      page.should have_content 'Jose Bartiella'
      page.should have_content 'Thiago'
      page.should have_content 'Nascimento'
    end
  end
  
  context 'after editing his information without a name' do
    before do
      fill_in 'name', :with => ''
      fill_in 'friends[0]', :with => 'Thiago'
      fill_in 'friends[1]', :with => 'Nascimento'
      click_button 'OK'
    end
    
    it 'should stay at /' do
      page.current_url.should_not =~ /done/
    end

    it 'should see his old name and his old friends still listed at /nightclubbers' do
      visit '/nightclubbers'
      page.should have_content 'Filipe Sabella'
      page.should have_content 'Marano'
      page.should have_content 'Pedro'
    end
  end
  
  context 'after removing' do
    before do
      click_button 'Deletar'
      click_button 'Sim'
    end
    
    it 'should stay at /' do
      page.current_url.should_not =~ /done/
    end

    it 'should not see himself and his friends listed at /nightclubbers' do
      visit '/nightclubbers'
      page.should have_no_content 'Filipe Sabella'
      page.should have_no_content 'Marano'
      page.should have_no_content 'Pedro'
    end
  end
  
  after do
    Nightclubber.where(:email => 'lipe@gmail.com').delete
  end

end
