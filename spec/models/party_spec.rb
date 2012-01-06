describe Party do

  context 'with discount list' do

    before :each do
      nav = fake_navigator mock

      @list = mock
      DiscountList.stub!(:new).and_return @list

      @party = Party.new nav
    end

    it 'should be nice' do
      @party.should be_nice
    end

    it 'should have a name' do
      @party.name.should be == 'London Calling'
    end

    it 'shold have an url' do
      @party.url.should be == 'www.cabaretpoa.com/london_calling.htm'
    end

    it 'should be able to add a nightclubber to the list' do
      sabella = Nightclubber.new('Sabella', 'lipe@gmail.com', ['Marano'])
      @list.should_receive(:add).with(sabella)
      @party.add_to_list(sabella)
    end
    
    it 'should use its url as identity' do
      other = mock
      other.stub!(:url).and_return 'www.cabaretpoa.com/london_calling.htm'
      @party.should be == other
    end

  end

  context 'without discount list' do

    before :each do
      nav = fake_navigator
      @party = Party.new nav
    end

    it 'should not be nice' do
      @party.should_not be_nice
    end

    it 'should still have a name though' do
      @party.name.should be == 'London Calling'
    end

  end
  
  it 'should find all available parties for all clubs' do
    beco = mock
    fuckrehab = mock
    discorock = mock
    beco.stub!(:parties).and_return [fuckrehab, discorock]
    
    cabaret = mock
    amnesia = mock
    londoncalling = mock
    cabaret.stub!(:parties).and_return [amnesia, londoncalling]
    
    Nightclub.stub!(:all).and_return [beco, cabaret]
    
    Party.all.should == [fuckrehab, discorock, amnesia, londoncalling]
  end

  def fake_navigator list_nav=nil
    nav = mock
    nav.stub!(:find_name).and_return 'London Calling'
    nav.stub!(:url).and_return 'www.cabaretpoa.com/london_calling.htm'
    nav.stub!(:navigate_to_list).and_return list_nav
    nav
  end
end

