#encoding: utf-8

describe 'A new nightclubber', :type => :request do

  before :all do
    Nightclubber.delete_all
  end

  context 'joining with required information' do

    before :all do
      visit '/'
      fill_in 'name', :with => 'Silvio Santos'
      fill_in 'email', :with => 'silvio@sbt.com.br'
      fill_in 'friends[0]', :with => 'Lombardi'
      fill_in 'friends[1]', :with => 'Roque'
      fill_in 'friends[2]', :with => 'Pedro de Lara'
      fill_in 'friends[3]', :with => 'Celso Portioli'
      click_button 'OK'
    end

    it 'should be redirected to /done' do
      page.current_url.should =~ /done/
    end

    it 'should to see himself and his friends listed at /nightclubbers' do
      visit '/nightclubbers'
      page.should have_content 'Silvio Santos'
      page.should have_content 'Lombardi'
      page.should have_content 'Roque'
      page.should have_content 'Pedro de Lara'
      page.should have_content 'Celso Portioli'
    end
    
    context 'and again with the same email' do 
      
      before :all do
        visit '/'
        fill_in 'name', :with => 'Senor Abravanel'
        fill_in 'email', :with => 'silvio@sbt.com.br'
        click_button 'OK'
      end
            
      it 'should see the error message at /' do
        page.current_url.should_not =~ /done/
        page.should have_content 'Email j&aacute cadastrado :('
      end

    end
    
    after :all do
      Nightclubber.where(:email => 'silvio@sbt.com.br').delete
    end
    
  end

  context 'should not be able to join when' do
    
    before do
      visit '/'
    end
    
    it 'does not provide a name' do
      fill_in 'email', :with => 'silvio@sbt.com.br'
    end

    it 'does not provide an email' do
      fill_in 'name', :with => 'Silvio Santos'
    end

    after do
      click_button 'OK'
      page.current_url.should_not =~ /done/
      visit '/nightclubbers'
      page.should have_no_content 'Silvio Santos'
    end
    
  end

end
