require 'rails_helper'

describe Party do
  describe '#id' do
    subject { Party.new({'public_id' => '99'}) }
    specify { expect(subject.id).to eq('99') }
  end
end
