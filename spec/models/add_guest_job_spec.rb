require 'rails_helper'

describe AddGuestJob, :type => :model do
  let(:beco) { build(:nightclub) }

  subject { AddGuestJob.new(beco) }

  describe '#run' do
    let(:bro) { build(:user) }
    let(:sis) { build(:user) }
    let(:dude) { build(:user) }

    before do
      allow(User).to receive(:guest_line).and_return [bro, sis, dude]
      allow(beco).to receive(:add_guest).with(bro).and_return(bro_status)
      allow(beco).to receive(:add_guest).with(sis).and_return(sis_status)
      allow(beco).to receive(:add_guest).with(dude).and_return(dude_status)
      subject.run
    end

    context 'bro is not a guest' do
      let(:bro_status) { 201 }
      let(:sis_status) { 201 }
      let(:dude_status){ 201 }

      specify do
        expect(beco).to have_received(:add_guest).with(bro)
      end
    end

    context 'bro is a guest but sis is not' do
      let(:bro_status) { 204 }
      let(:sis_status) { 201 }
      let(:dude_status){ 201 }

      specify do
        expect(beco).to have_received(:add_guest).with(bro)
        expect(beco).to have_received(:add_guest).with(sis)
      end
    end

    context 'bro and sis are guests but dude is not' do
      let(:bro_status) { 204 }
      let(:sis_status) { 204 }
      let(:dude_status){ 201 }

      specify do
        expect(beco).to have_received(:add_guest).with(bro)
        expect(beco).to have_received(:add_guest).with(sis)
        expect(beco).to have_received(:add_guest).with(dude)
      end
    end

    context 'everyone is a guest already' do
      let(:bro_status) { 204 }
      let(:sis_status) { 204 }
      let(:dude_status){ 201 }

      specify do
        expect(beco).to have_received(:add_guest).with(bro)
        expect(beco).to have_received(:add_guest).with(sis)
        expect(beco).to have_received(:add_guest).with(dude)
      end
    end
  end
end

