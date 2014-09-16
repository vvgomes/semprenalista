class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :nightclub

  class << self
    def next(club)
      where(:nigthclub => club).order('created_at asc').first.user
    end
  end
end
