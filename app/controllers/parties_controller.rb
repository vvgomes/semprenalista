class PartiesController < ApplicationController
  before_filter :authenticate!

  def index
    @parties = Club.parties
  end
end
