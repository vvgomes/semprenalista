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

    context 'when initializing' do
      before do
        allow(User).to receive(:where).and_return(User)
        allow_any_instance_of(User).to receive(:save!)
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
end
