require 'rails_helper'

describe PartiesController, :type => :controller do
  let(:dude) { create(:user, :provider => 'facebook', :uid => '666') }
  let(:parties) { double }

  before { allow(Club).to receive(:parties).and_return(parties) }

  describe '#index' do
    context 'when no one is logged in' do
      before  { get :index }
      specify { expect(response).to redirect_to root_url }
    end

    context 'when a user is logged in' do
      before  { session[:user_id] = dude.id }
      before  { get :index }
      specify { expect(response).to be_success }
      specify { expect(assigns(:parties)).to eq(parties) }
    end
  end
end
