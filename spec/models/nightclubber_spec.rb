require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclubber')

describe 'Nightclubber' do
  
  before :each do
    @fulvio = Nightclubber.new 'Fulvio Silas', 'fulvio@gmail.com', ['Jairo', 'Gilda']
  end
  
  it 'should have a name' do
    @fulvio.name.should be_eql 'Fulvio Silas'
  end
  
  it 'should have an email' do
    @fulvio.email.should be_eql 'fulvio@gmail.com'
  end
  
  it 'should tell me who are his friends' do
    @fulvio.friends.should be_eql ['Jairo', 'Gilda']
  end

end