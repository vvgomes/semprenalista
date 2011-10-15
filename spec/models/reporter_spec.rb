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

    Report.should_receive(:new).
      with('Cabaret', 'Amnesia', 'Sabella', 200, 'ok').
      and_return report
    report.should_receive :save

    @reporter.save(club, party, clubber, response)
  end

  it 'should build human-readable report list' do
    r1 = mock
    r2 = mock

    Report.stub!(:all).and_return [r1, r2]
    r1.stub!(:to_s).and_return '10/12/2011 12:00:00PM - Cabaret - Amnesia - Filipe Sabella and friends : 200 [ok]'
    r2.stub!(:to_s).and_return '10/12/2011 12:00:00PM - Cabaret - Amnesia - Luis Inacio da Silva and friends: 200 [ok]'

    @reporter.reports.should be_eql [
      '10/12/2011 12:00:00PM - Cabaret - Amnesia - Filipe Sabella and friends : 200 [ok]',
      '10/12/2011 12:00:00PM - Cabaret - Amnesia - Luis Inacio da Silva and friends: 200 [ok]'
    ]
  end

end

