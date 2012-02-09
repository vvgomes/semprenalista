require 'selenium-webdriver'

describe 'A new nightclubber' do
  HOME = 'http://127.0.0.1:9292'
  
  before :all do
    @driver = Selenium::WebDriver.for :firefox
  end
  
  after :all do
    @driver.quit
  end
  
  context 'when joing with valid information' do 
    
    before :all do
      @driver.navigate.to HOME
      @driver.find_element(:name, 'name').send_keys 'Silvio Santos'
      @driver.find_element(:name, 'email').send_keys 'silvio@sbt.com.br'
      @driver.find_element(:name, 'friends[0]').send_keys 'Lombardi'
      @driver.find_element(:name, 'friends[1]').send_keys 'Roque'
      @driver.find_element(:name, 'friends[2]').send_keys 'Pedro de Lara'
      @driver.find_element(:name, 'friends[3]').send_keys 'Celso Portioli'
      @driver.find_element(:id, 'ok').click
    end

    after :all do
      Nightclubber.where(:email => 'silvio@sbt.com.br').delete
    end
    
    it 'should be redirected to /done' do
      @driver.current_url.should be == "#{HOME}/done"
    end
    
    it 'should be listed in /nightclubbers' do
      @driver.navigate.to "#{HOME}/nightclubbers"
      @driver.page_source.should include 'Silvio Santos'
    end
    
    it 'should have his friends listed in /nightclubbers' do
      @driver.navigate.to "#{HOME}/nightclubbers"
      @driver.page_source.should include 'Lombardi'
      @driver.page_source.should include 'Roque'
      @driver.page_source.should include 'Pedro de Lara'
      @driver.page_source.should include 'Celso Portioli'
    end
    
  end
  
  context 'when joing without his name' do
    
    before :all do
      @driver.navigate.to HOME
      @driver.find_element(:name, 'email').send_keys 'silvio@sbt.com.br'
      @driver.find_element(:id, 'ok').click
    end
    
    it 'should stay at /' do
      @driver.current_url.should be == "#{HOME}/"
    end
    
  end
    
  context 'when joing without his email' do
    
    before :all do
      @driver.navigate.to HOME
      @driver.find_element(:name, 'name').send_keys 'Silvio Santos'
      @driver.find_element(:id, 'ok').click
    end
    
    it 'should stay at /' do
      @driver.current_url.should be == "#{HOME}/"
    end
    
    it 'should not be listed at /nightclubbers' do
      @driver.navigate.to "#{HOME}/nightclubbers"
      @driver.page_source.should_not include 'Silvio Santos'
    end
    
  end
  
  context 'when joing again' do
    
    before :all do
      2.times do
        @driver.navigate.to HOME
        @driver.find_element(:name, 'name').send_keys 'Silvio Santos'
        @driver.find_element(:name, 'email').send_keys 'silvio@sbt.com.br'
        @driver.find_element(:id, 'ok').click
      end
    end
    
    after :all do
      Nightclubber.where(:email => 'silvio@sbt.com.br').delete
    end
    
    it 'should stay at /' do
      @driver.current_url.should be == "#{HOME}/"
    end
    
    it 'should see the error message' do
      message = @driver.find_element(:class, 'error').text
      message.should be == 'Email já cadastrado :('
    end
    
  end
    
end