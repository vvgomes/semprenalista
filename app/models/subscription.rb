class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :club

  class << self
    def next(club)
      where(:club => club).order('created_at asc').first.user
    end
  end
end
