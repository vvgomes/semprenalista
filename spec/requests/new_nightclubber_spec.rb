describe 'A new nightclubber', :type => :request do

  before :all do
    Nightclubber.delete_all
  end

  context 'after joining' do
    before :all do
      visit '/'
      fill_in 'name', :with => 'Filipe Sabella'
      fill_in 'email', :with => 'lipe@gmail.com'
      fill_in 'friends[0]', :with => 'Marano'
      fill_in 'friends[1]', :with => 'Pedro'
      fill_in 'friends[2]', :with => 'Ygor'
      fill_in 'friends[3]', :with => 'Duda'
      click_button 'OK'
    end

    it 'should be redirected to /done' do
      page.current_url.should =~ /done/
    end

    it 'should to see himself and his friends listed at /nightclubbers' do
      visit '/nightclubbers'
      page.should have_content 'Filipe Sabella'
      page.should have_content 'Marano'
      page.should have_content 'Pedro'
      page.should have_content 'Ygor'
      page.should have_content 'Duda'
    end
              
    it 'should not be able to join again with the same email' do
      visit '/'
      fill_in 'name', :with => 'Jose Bartiella'
      fill_in 'email', :with => 'lipe@gmail.com'
      click_button 'OK'
      
      page.current_url.should_not =~ /done/
      page.should have_content 'Email j&aacute cadastrado :('
    end
    
    after :all do
      Nightclubber.where(:email => 'lipe@gmail.com').delete
    end
  end

  context 'should not be able to join when' do
    before do
      visit '/'
    end
    
    it 'does not provide a name' do
      fill_in 'email', :with => 'lipe@gmail.com'
    end

    it 'does not provide an email' do
      fill_in 'name', :with => 'Filipe Sabella'
    end

    after do
      click_button 'OK'
      page.current_url.should_not =~ /done/
      visit '/nightclubbers'
      page.should have_no_content 'Filipe Sabella'
    end
  end

end
