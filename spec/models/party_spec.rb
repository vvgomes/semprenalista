require 'rails_helper'

describe Party do
  subject(:party) { Party.new(:public_id => 'foo') }

  describe '#public_id' do
    specify { expect(party.public_id).to eq('foo') }
  end

  describe '#==' do
    specify 'same public_id' do
      expect(party).to eq(Party.new(:public_id => 'foo'))
    end

    specify 'different public_id' do
      expect(party).not_to eq(Party.new(:public_id => 'bar'))
    end
  end
end
