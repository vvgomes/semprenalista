require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Reporter' do

  before :each do
    @reporter = Reporter.new
  end

  it 'should clean the subscription report collection' do
    Report.should_receive(:delete_all)
    @reporter.clean
  end

  it 'should save a subscription report' do
    club = mock
    party = mock
    clubber = mock
    response = mock
    report = mock

    club.stub!(:name).and_return 'Cabaret'
    party.stub!(:name).and_return 'Amnesia'
    clubber.stub!(:name).and_return 'Sabella'
    response.stub!(:code).and_return 200
    response.stub!(:message).and_return 'ok'
    Report.stub!(:new).and_return report

    report.should_receive :save

    @reporter.save(club, party, clubber, response)
  end

end

