describe Nightclubber do

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

  context 'when parsing request parameters' do

    before :each do
      params = {
        :name => 'Filipe Sabella',
        :email => 'lipe@gmail.com',
        :friends => {
          :f0 => 'Marano',
          :f1 => 'Pedro',
          :f2 => '',
          :f3 => ''
        }
      }
      @sabella = Nightclubber.parse params
    end

    it 'should be able to extract the name' do
      @sabella.name.should be_eql 'Filipe Sabella'
    end

    it 'should be able to extract the email' do
      @sabella.email.should be_eql 'lipe@gmail.com'
    end

    it 'should be able to extract the friends' do
      @sabella.friends.to_set.should be_eql ['Marano', 'Pedro'].to_set
    end

  end

  it 'should give me all people names sorted' do
    zilda = Nightclubber.new 'Zilda', 'mail', ['Abraao']
    magda = Nightclubber.new 'Magda', 'mail', ['Crenildo']
    Nightclubber.stub!(:all).and_return [zilda, magda]
    Nightclubber.sorted_names.should be_eql ['Abraao', 'Crenildo', 'Magda', 'Zilda']
  end

  it 'should create an empty new guy' do
    empty = Nightclubber.empty
    empty.name.should be_eql ''
    empty.email.should be_eql ''
    empty.friends.each{|f| f.should be_eql ''}
  end

end

