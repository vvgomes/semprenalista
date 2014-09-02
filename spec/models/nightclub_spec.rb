require 'rails_helper'

describe Nightclub, :type => :model do
  subject(:beco) { Nightclub.new(:name => 'Beco') }
  let(:partybot) { double.as_null_object }

  before do
    allow(PartybotClient).to receive(:new).and_return(partybot)
  end

  describe '#name' do
    specify { expect(beco.name).to eq('Beco') }
  end

  describe '#==' do
    specify 'same name' do
      expect(beco).to eq(Nightclub.new(:name => 'Beco'))
    end

    specify 'different name' do
      expect(beco).not_to eq(Nightclub.new(:name => 'Lab'))
    end
  end

  describe '#parties' do
    before do
      allow(partybot).to receive(:parties).
      and_return [{ 'public_id' => 'foo' }, { 'public_id' => 'bar' }]
    end

    let(:parties) { beco.parties }

    specify 'size' do
      expect(parties.size).to eq(2)
    end

    specify 'content' do
      expect(parties.map(&:public_id)).to eq(['foo', 'bar'])
    end
  end

  describe '#parties (with filters)' do
    before do
      allow(partybot).to receive(:parties).
      with(:missing => 'dude@gmail.com').
      and_return [{ 'public_id' => 'foo' }]
    end

    let(:parties) { beco.parties(:missing => 'dude@gmail.com') }

    specify 'size' do
      expect(parties.size).to eq(1)
    end

    specify 'content' do
      expect(parties.map(&:public_id)).to eq(['foo'])
    end
  end

  describe '#subscribe' do
    let(:user) { User.new(:name => 'Dude', :email => 'dude@gmail.com') }
    let(:p1) { Party.new(:public_id => 'foo') }
    let(:p2) { Party.new(:public_id => 'bar') }

    before { beco.subscribe(user, [p1, p2]) }

    specify do
      expect(partybot).to have_received(:subscribe).with(
        { :name => 'Dude', :email => 'dude@gmail.com'}, ['foo', 'bar']
      )
    end
  end
end
