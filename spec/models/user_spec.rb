require 'rails_helper'

describe User, :type => :model do

  describe '.from_omniauth' do
    let(:auth) do
      OmniAuth::AuthHash.new({
        :provider => 'facebook',
        :uid => '123',
        :info => {
          :name => 'Dude',
          :email => 'dude@gmail.com',
          :image => 'dude.jpg'
        },
        :credentials => {
          :token => '321',
          :expires_at => 1408676034
        }
      })
    end

    before do
      allow(User).to receive(:where).and_return(User)
      allow_any_instance_of(User).to receive(:save!)
      allow_any_instance_of(User).to receive(:issue_all_tickets!)
    end

    subject { User.from_omniauth(auth) }
    specify { expect(subject.provider).to eq('facebook') }
    specify { expect(subject.uid).to eq('123') }
    specify { expect(subject.name).to eq('Dude') }
    specify { expect(subject.email).to eq('dude@gmail.com') }
    specify { expect(subject.image).to eq('dude.jpg') }
    specify { expect(subject.oauth_token).to eq('321') }
    specify { expect(subject.oauth_expires_at).to eq(Time.at(1408676034)) }
  end

  describe '#to_h' do
    subject { build(:user, :name => 'Dude', :email => 'dude@gmail.com') }

    specify do
      expect(subject.to_h).to eq({
        :name => 'Dude',
        :email => 'dude@gmail.com'
      })
    end
  end

  describe '#==' do
    subject { build(:user, :email => 'dude@gmail.com') }

    specify 'same email' do
      expect(subject).to eq(User.new(:email => 'dude@gmail.com'))
    end

    specify 'different email' do
      expect(subject).not_to eq(User.new(:email => 'sis@gmail.com'))
    end
  end

  describe '#issue_tickets!' do
    subject { build(:user) }
    let(:club) { build(:nightclub)  }
    let(:args) { { :user => subject, :nightclub => club } }

    specify do
      expect(Ticket).to receive(:delete_all).with(args)
      expect(Ticket).to receive(:create).with(args)
      subject.issue_ticket!(club)
    end
  end

  describe '#issue_all_tickets!' do
    subject { build(:user) }
    let(:club) { build(:nightclub)  }

    before do
      allow(Nightclub).to receive(:all).and_return [club]
    end

    specify do
      expect(subject).to receive(:issue_ticket!).with(club)
      subject.issue_all_tickets!
    end
  end
end
