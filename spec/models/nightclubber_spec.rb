require File.expand_path(File.dirname(__FILE__) + '/../../app/models/nightclubber')

describe 'Nightclubber' do
  
  before :each do
    @fulvio = Nightclubber.new 'Fulvio Silas', 'fulvio@gmail.com'
  end
  
  it 'should have a name' do
    @fulvio.name.should be_eql 'Fulvio Silas'
  end
  
  it 'should have an email' do
    @fulvio.email.should be_eql 'fulvio@gmail.com'
  end
  
  context 'when partying alone' do
  
    it 'should be going to dance with himself' do
      @fulvio.should be_alone
    end
  
  end
  
  context 'when partying together' do
    
    before :each do
      @fulvio.take 'Jairo'
      @fulvio.take 'Gilda'
    end
    
    it 'should not be going to dance alone' do
      @fulvio.should_not be_alone
    end
    
    it 'should tell me who are his friends' do
      @fulvio.friends.should be_eql ['Jairo', 'Gilda']
    end
  
  end

end