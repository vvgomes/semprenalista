require File.expand_path(File.dirname(__FILE__) + '/../../app/models/cabaret')

describe 'Cabaret::Party' do

  before :each do
    @page = mock
    @london_calling = Cabaret::Party.new @page
  end

  it 'should give me its name based on page structure' do
    title = mock
    title.stub!(:text).and_return 'LONDON CALLING'
    @page.should_receive(:search).with('div#texto > h2').and_return [title]
    @london_calling.name.should be_eql 'LONDON CALLING'
  end

  it 'should not be a nice party when there is no discount list' do
    @page.should_receive(:link_with).with(:text => /enviar nome para a lista/i).and_return nil
    @london_calling.should_not be_nice
  end

  it 'should be a nice party when there is a discount list' do
    @page.should_receive(:link_with).with(:text => /enviar nome para a lista/i).and_return mock
    @london_calling.should be_nice
  end

end

