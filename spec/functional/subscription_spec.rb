require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

describe 'Subscription' do
  
  before :all do
    clear_db
    configure_matchers
  end
  
  before :each do
    create_nightclubber
    prevent_form_submission
    @job = Job.new
  end
  
  after :each do
    clear_db
  end
  
  it 'should subscribe an existing nightclubber and save a report' do
    @job.run
    reports = Report.where(:email => 'lipe@gmail.com').to_a
    reports.should_not be_empty
    reports.should include_all_available_parties
  end
  
  context 'when everybody have already been subscribed' do
    
    before :each do
      @job.run # adding the lonely nightclubber
    end
    
    it 'should log it' do
      @job.should_receive :log
      @job.run
      Report.all.to_a.should_not be_empty
    end

    it 'should remove all reports on monday' do
      make_it_monday
      @job.run
      Report.all.to_a.should be_empty
    end
    
  end
  
  def create_nightclubber
    Nightclubber.new('Sabella', 'lipe@gmail.com', ['Marano']).save
  end
  
  def prevent_form_submission
    response_page = mock
    response_body = mock
    
    response_page.stub!(:code).and_return 200
    response_page.stub!(:search).and_return [response_body]
    response_body.stub!(:text).and_return 'ok'
    
    [Beco, Cabaret].each{ |n| n.stub!(:submit).and_return response_page }
  end
  
  def make_it_monday
    @job.stub!(:monday?).and_return true
  end
  
  def clear_db
    Nightclubber.delete_all
    Report.delete_all
  end
  
  def configure_matchers
    RSpec::Matchers.define :include_all_available_parties do
      match do |reports|
        party_names = Nightclub.all.to_a.inject([]) do |result, club|
          result + club.parties.map{|p| p.name}
        end
        reports.each do |r|
          return false if !party_names.include? r.party
        end
        true
      end
    end
  end
  
end