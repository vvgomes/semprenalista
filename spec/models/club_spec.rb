require 'rails_helper'

describe Club, :type => :model do
  subject { Club.new(:name => 'beco') }
  let(:partybot) { double.as_null_object }

  before do
    allow(PartybotClient).to receive(:new).and_return(partybot)
  end

  describe '#name' do
    specify { expect(subject.name).to eq('beco') }
  end

  describe '#==' do
    specify 'same name' do
      expect(subject).to eq(Club.new(:name => 'beco'))
    end

    specify 'different name' do
      expect(subject).not_to eq(Club.new(:name => 'lab'))
    end
  end

  describe '#parties' do
    before do
      allow(partybot).to receive(:parties).
      and_return [{ 'public_id' => 'foo' }, { 'public_id' => 'bar' }]
    end

    let(:parties) { subject.parties }

    specify 'size' do
      expect(parties.size).to eq(2)
    end

    specify 'content' do
      expect(parties.map(&:public_id)).to eq(['foo', 'bar'])
    end
  end

  describe '.parties' do
    let(:clubs) do
      [
        double(:name => 'beco', :parties => [:fuckrehab, :discorock]),
        double(:name => 'cucko', :parties => [:london, :rockwork])
      ]
    end

    before do
      allow(Club).to receive(:all).and_return(clubs)
    end

    specify do
      expect(Club.parties).to eq([:fuckrehab, :discorock, :london, :rockwork])
    end
  end

  describe '#add_guest' do
    let(:dude) { build(:user, :name => 'Dude', :email => 'dude@gmail.com') }

    specify do
      expect(dude).to receive(:update_subscription).with(subject)
      expect(partybot).to receive(:add_guest).with(:name => 'Dude', :email => 'dude@gmail.com')
      subject.add_guest(dude)
    end
  end
end
