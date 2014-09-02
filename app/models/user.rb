class User < ActiveRecord::Base
  has_many :tickets

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
      user.issue_all_tickets!
    end
  end

  def ==(other)
    self.email == other.email
  end

  def to_h
    { :name => name, :email => email }
  end

  def issue_ticket!(club)
    Ticket.delete_all(:user => self, :nightclub => club)
    Ticket.create(:user => self, :nightclub => club)
  end

  def issue_all_tickets!
    Nightclub.all.each{ |c| issue_ticket!(c) }
  end
end
