require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Report' do

  before :each do
    @report = Report.new 'Cabaret', 'Amnesia', 'Sabella', 200, 'ok'
  end

  it 'should have the nightclub name' do
    @report.club.should be_eql 'Cabaret'
  end

  it 'should have the party name' do
    @report.party.should be_eql 'Amnesia'
  end

  it 'should have the nightclubber name' do
    @report.clubber.should be_eql 'Sabella'
  end

  it 'should have the response code' do
    @report.code.should be 200
  end

  it 'should have the response message' do
    @report.message.should be_eql 'ok'
  end

end

