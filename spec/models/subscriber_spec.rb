describe Subscriber do

  before :each do
    @subscriber = Subscriber.new
  end

  it 'should give me the nightclubs' do
    beco = mock
    cabaret = mock

    @subscriber.add beco
    @subscriber.add cabaret

    @subscriber.nightclubs.should be_eql [beco, cabaret]
  end

  context 'when subscribing' do

    before :each do
      @subscriber.stub!(:save_report)
    end

    it 'should subscribe a nightclubber to the available discount lists' do
      sabella = mock
      cabaret = mock
      amnesia = mock

      sabella.stub!(:class).and_return Nightclubber
      cabaret.stub!(:parties).and_return [amnesia]
      amnesia.should_receive(:add_to_list).with sabella

      @subscriber.add cabaret
      @subscriber.subscribe sabella
    end

    it 'should subscribe all nightclubbers to the available discount lists' do
      marano = mock
      sabella = mock
      cabaret = mock
      amnesia = mock

      Report.stub!(:delete_all)
      Nightclubber.stub!(:all).and_return [marano, sabella]
      cabaret.stub!(:parties).and_return [amnesia]

      amnesia.should_receive(:add_to_list).once.with marano
      amnesia.should_receive(:add_to_list).once.with sabella

      @subscriber.add cabaret
      @subscriber.subscribe_everybody
    end
  end

  context 'when reporting its actions' do

    it 'should show me the reports for the last subscriptions' do
      report = mock
      report.stub!(:to_s).and_return 'something happened on Monday.'
      Report.stub!(:all).and_return [report]

      @subscriber.reports.should be_eql ['something happened on Monday.']
    end

    it 'should save a report after subscribing a clubber' do
      cabaret = mock
      amnesia = mock
      response = mock
      report = mock

      cabaret.stub!(:name).and_return 'Cabaret'
      cabaret.stub!(:parties).and_return [amnesia]
      amnesia.stub!(:add_to_list).and_return response
      amnesia.stub!(:name).and_return 'Amnesia'
      response.stub!(:message).and_return 'ok'
      response.stub!(:code).and_return 200

      Report.should_receive(:new).
        with('Cabaret', 'Amnesia', 'Sabella', 200, 'ok').and_return report

      report.should_receive(:save)

      sabella = Nightclubber.new 'Sabella', 'lipe@gmail.com', ['Marano']
      @subscriber.add cabaret
      @subscriber.subscribe sabella
    end

  end

  it 'should be able to create a subscriber with nightclubs' do
    [Cabaret, Beco].each{|x|x.stub!(:get).and_return mock}
    subscriber = Subscriber.create
    subscriber.nightclubs.map{|n|n.name}.should be_eql ['Cabaret', 'Beco']
  end

end

