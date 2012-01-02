describe Job do

    before :each do
      @job = Job.new
      @sabella = Nightclubber.new 'Sabella', 'lipe@gmail.com', []
      Nightclubber.stub!(:all).and_return [@sabella]
    end
    
    context 'when subscribing people' do
      
      before :each do
        cabaret = mock
        cabaret = mock
        @response = mock
        @rockpocket = mock
        
        Nightclub.stub!(:all).and_return [cabaret]
        cabaret.stub!(:parties).and_return [@rockpocket]
        cabaret.stub!(:name).and_return 'cabaret'
        
        @rockpocket.stub!(:name).and_return 'rockpocket'
        @response.stub!(:code).and_return 200
        @response.stub!(:message).and_return 'ok'
      end

      it 'should find someone not subscribed yet' do      
        Report.stub!(:where).with(:email => 'lipe@gmail.com').and_return nil
        @job.stub!(:save_report)
      
        @rockpocket.should_receive(:add_to_list).with(@sabella).and_return @response
      
        @job.run
      end
    
      it 'should save a new report' do
        @job.stub!(:not_subscribed_yet).and_return @sabella
        @rockpocket.stub!(:add_to_list).and_return @response
        
        report = mock
        Report.should_receive(:new).with('cabaret', 'rockpocket', 'lipe@gmail.com', 200, 'ok').and_return(report)
        report.should_receive(:save)
      
        @job.run
      end
    
    end
    
    context 'when everybody has already been subscribed' do
      
      it 'should remove all reports on monday' do
        @job.stub!(:monday?).and_return true
        Report.stub!(:where).with(:email => 'lipe@gmail.com').and_return @sabella
        
        Report.should_receive(:delete_all)
        
        @job.run
      end
      
      it 'should do nothing the other days' do
        @job.stub!(:monday?).and_return false
        Report.stub!(:where).with(:email => 'lipe@gmail.com').and_return @sabella
        
        Report.should_not_receive(:delete_all)
        
        @job.run
      end
      
    end

end

