require 'rails_helper'

describe User, :type => :model do

  describe 'class methods' do
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
        allow_any_instance_of(User).to receive(:subscribe_to_all_clubs!)
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
  end

  describe 'instance methods' do
    subject do
      build(:user, :name => 'Dude', :email => 'dude@gmail.com')
    end

    describe '#to_h' do
      specify do
        expect(subject.to_h).to eq({
          :name => 'Dude',
          :email => 'dude@gmail.com'
        })
      end
    end

    describe '#==' do
      specify 'same email' do
        expect(subject).to eq(User.new(:email => 'dude@gmail.com'))
      end

      specify 'different email' do
        expect(subject).not_to eq(User.new(:email => 'sis@gmail.com'))
      end
    end

    describe '#subscribe_to_all_clubs!' do
      let(:club) { build(:club)  }

      before do
        allow(Club).to receive(:all).and_return [club]
      end

      specify do
        expect(Subscription).to receive(:create).with({
          :club => club,
          :user => subject
        })
        subject.subscribe_to_all_clubs
      end
    end

    describe '#update_subscription' do
      let(:club) { build(:club) }
      let(:subs) { build(:subscription, :club => club) }

      before do
        allow(subject).to receive(:subscription_for).and_return(subs)
      end

      specify do
        expect(subs).to receive(:touch)
        subject.update_subscription(club)
      end
    end
  end
end
