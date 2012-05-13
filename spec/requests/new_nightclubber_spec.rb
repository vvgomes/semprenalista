describe 'A new nightclubber', :type => :request do

  before :all do
    Nightclubber.delete_all
  end

  after :all do
    Nightclubber.delete_all
  end

  it 'should see the success message after joining with valid information' do
    visit '/'
    fill_in 'name', :with => 'Filipe Sabella'
    fill_in 'email', :with => 'lipe@gmail.com'
    fill_in 'friends[0]', :with => 'Marano'
    fill_in 'friends[1]', :with => 'Pedro'
    fill_in 'friends[2]', :with => 'Ygor'
    fill_in 'friends[3]', :with => 'Duda'
    click_button 'submit'
    page.should have_content 'Feito! Voce está em todas as listas para sempre :)'
  end

  it 'should not be able to join without a name' do
    visit '/'
    fill_in 'email', :with => 'lipe@gmail.com'
    fill_in 'friends[0]', :with => 'Marano'
    fill_in 'friends[1]', :with => 'Pedro'
    fill_in 'friends[2]', :with => 'Ygor'
    fill_in 'friends[3]', :with => 'Duda'
    click_button 'submit'
    page.should have_no_content 'Feito! Voce está em todas as listas para sempre :)'
  end

  it 'should not be able to join without an email' do
    visit '/'
    fill_in 'name', :with => 'Filipe Sabella'
    fill_in 'friends[0]', :with => 'Marano'
    fill_in 'friends[1]', :with => 'Pedro'
    fill_in 'friends[2]', :with => 'Ygor'
    fill_in 'friends[3]', :with => 'Duda'
    click_button 'submit'
    page.should have_no_content 'Feito! Voce está em todas as listas para sempre :)'
  end

end
