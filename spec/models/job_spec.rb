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
        @job.stub!(:log)
      end

      it 'should find someone not subscribed yet' do      
        Report.stub!(:where).with(:email => 'lipe@gmail.com').and_return []
        @job.stub!(:save_report)
      
        @rockpocket.should_receive(:add_to_list).with(@sabella).and_return @response
      
        @job.run
      end
      
      it 'should find someone by email' do
        mongoid_thing = mock
        mongoid_thing.stub! :delete_all
        Report.stub!(:where).with(:email => 'lipe@gmail.com').and_return mongoid_thing
        Nightclubber.stub!(:where).with(:email => 'lipe@gmail.com').and_return [@sabella]
        @job.stub!(:save_report)
        
        @rockpocket.should_receive(:add_to_list).with(@sabella).and_return @response
      
        @job.run 'lipe@gmail.com'
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
        Report.stub!(:where).with(:email => 'lipe@gmail.com').and_return [@sabella]
        @job.stub!(:log)
        
        Report.should_receive(:delete_all)
        
        @job.run
      end
      
      it 'should log it every run except on monday' do
        @job.stub!(:monday?).and_return false
        Report.stub!(:where).with(:email => 'lipe@gmail.com').and_return [@sabella]
        
        @job.should_receive(:log).with('Everybody is subscribed to all lists already.')
        
        @job.run
      end
      
    end

end

