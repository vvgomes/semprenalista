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
    end

    subject(:user) { User.from_omniauth(auth) }
    specify { expect(user.provider).to eq('facebook') }
    specify { expect(user.uid).to eq('123') }
    specify { expect(user.name).to eq('Dude') }
    specify { expect(user.email).to eq('dude@gmail.com') }
    specify { expect(user.image).to eq('dude.jpg') }
    specify { expect(user.oauth_token).to eq('321') }
    specify { expect(user.oauth_expires_at).to eq(Time.at(1408676034)) }
  end

  describe '#to_h' do
    subject(:user) do
      User.new(:name => 'Dude', :email => 'dude@gmail.com')
    end

    specify do
      expect(user.to_h).to eq({
        :name => 'Dude',
        :email => 'dude@gmail.com'
      })
    end
  end

  describe '#==' do
    subject(:user) do
      User.new(:email => 'dude@gmail.com')
    end

    specify 'same email' do
      expect(user).to eq(User.new(:email => 'dude@gmail.com'))
    end

    specify 'different email' do
      expect(user).not_to eq(User.new(:email => 'sis@gmail.com'))
    end
  end
end
