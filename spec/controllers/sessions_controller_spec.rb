require 'rails_helper'

describe SessionsController, :type => :controller do

  describe '#create' do
    let!(:dude) do
      create(:user, :provider => 'facebook', :uid => '666')
    end

    let(:auth) do
      OmniAuth::AuthHash.new({
        :provider => 'facebook', 
        :uid => '666',
        :info => {},
        :credentials => {
          :expires_at => Time.now.to_i
        }
      })
    end

    before do
      allow_any_instance_of(SessionsController).
        to receive(:env).and_return({ 'omniauth.auth' => auth })
    end

    before do
      get :create, :provider => 'facebook'
    end

    specify { expect(response).to have_http_status(302) }
    specify { expect(response).to redirect_to root_url }
    specify { expect(session[:user_id]).to eq(dude.id) }
  end
end
