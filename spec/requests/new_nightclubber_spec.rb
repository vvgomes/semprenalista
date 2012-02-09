#encoding: utf-8
require 'spec_helper'
describe 'A new nightclubber', :type => :request do
  before :all do
    Nightclubber.delete_all
  end
  context 'when joining with valid information' do

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

    after :all do
      Nightclubber.where(:email => 'silvio@sbt.com.br').delete
    end

    it 'should be redirected to /done' do
      page.current_url.should =~ /done/
    end

    context 'listing in /nightclubbers' do
      before do
        visit '/nightclubbers'
      end

      it 'should list the nightclubber' do
        page.should have_content 'Silvio Santos'
      end

      it 'should list nighclubbers frineds' do
        page.should have_content 'Lombardi'
        page.should have_content 'Roque'
        page.should have_content 'Pedro de Lara'
        page.should have_content 'Celso Portioli'
      end
    end
  end

  context 'when joining, do not add the nightclubber if' do
    before do
      visit '/'
    end
    pending 'has a name missing' do
      fill_in 'email', :with => 'silvio@sbt.com.br'
    end

    pending 'has an email missing' do
      fill_in 'name', :with => 'Silvio Santos'
    end

    after do
      click_button 'OK'
      page.current_url.should_not =~ /done/
      visit '/nightclubbers'
      page.should have_no_content 'Silvio Santos'
    end
  end

=begin
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

=end

end
