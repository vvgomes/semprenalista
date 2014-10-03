class PartiesController < ApplicationController
  before_filter :authenticate!
  caches_action :index, :expires_in => 6.hours

  def index
    @parties = Club.parties
  end
end
