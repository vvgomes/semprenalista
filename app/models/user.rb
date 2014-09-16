class User < ActiveRecord::Base
  has_many :subscriptions

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.image = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
      user.subscribe_to_all_clubs
    end
  end

  def ==(other)
    self.email == other.email
  end

  def to_h
    { :name => name, :email => email }
  end

  def subscribe_to_all_clubs
    Nightclub.all.each do |club|
      Subscription.create(:nightclub => club, :user => self)
    end
  end

  def update_subscription(club)
    subscription_for(club).touch
  end

  def self.guest_line(club)
    Subscription.
      where(:nightclub => club).
      order(:updated_at => :asc).
      map(&:user)
  end

  private

  def subscription_for(club)
    subscriptions.where(:club => club).first
  end
end
