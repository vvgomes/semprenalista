describe Nightclubber do
  
  context 'in normal conditions' do
    before :each do
      @sabella = Nightclubber.new 'Filipe Sabella', 'lipe@gmail.com', ['Marano', 'Pedro']
    end

    it 'should have a name' do
      @sabella.name.should be == 'Filipe Sabella'
    end

    it 'should have an email' do
      @sabella.email.should be == 'lipe@gmail.com'
    end

    it 'should tell me who are his friends' do
      @sabella.friends.should be == ['Marano', 'Pedro']
    end
  end

  context 'when parsing request parameters' do
    before :each do
      params = {
        :name => 'Jose Bartiella',
        :email => 'lipe@tw.com',
        :friends => {
          :f0 => 'Thiago',
          :f1 => 'Nascimento',
          :f2 => '',
          :f3 => ''
        }
      }
      @sabella = Nightclubber.parse params
    end

    it 'should be able to extract the name' do
      @sabella.name.should be == 'Jose Bartiella'
    end

    it 'should be able to extract the email' do
      @sabella.email.should be == 'lipe@tw.com'
    end

    it 'should be able to extract the friends' do
      @sabella.friends.to_set.should be == ['Thiago', 'Nascimento'].to_set
    end
  end
  
  context 'when searching the weekly subscriptions' do
    before :each do
      @sabella = Nightclubber.new 'Filipe Sabella', 'lipe@gmail.com', ['Marano', 'Pedro']
    end
    
    it 'should find all subscribed people' do
      Report.stub!(:where).with(:email => 'lipe@gmail.com').and_return [@sabella]
      Nightclubber.stub!(:all).and_return [@sabella]
      Nightclubber.all_subscribed.should be == [@sabella]
    end

    it 'should find all people not subscribed yet' do
      #Nightclubber.all_not_subscribed
    end
  end

  it 'should create an empty new instance' do
    empty = Nightclubber.empty
    empty.name.should be == ''
    empty.email.should be == ''
    empty.friends.each{|f| f.should be == ''}
  end
  
  it 'should give me all people names sorted' do
    zilda = Nightclubber.new 'Zilda', 'mail', ['Abraao']
    magda = Nightclubber.new 'Magda', 'mail', ['Crenildo']
    Nightclubber.stub!(:all).and_return [zilda, magda]
    Nightclubber.sorted_names.should be == ['Abraao', 'Crenildo', 'Magda', 'Zilda']
  end

end

