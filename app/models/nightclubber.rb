require 'mongoid'

class Nightclubber
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :email, :type => String
  field :friends, :type => Array, :default => []
  
  embeds_many :subscriptions

  validates_uniqueness_of :email

  def initialize name, email, friends
    super :name => name, :email => email, :friends => friends
  end
  
  def ==(other)
    other.email == email
  end
  
  def add subscription
    subscriptions << subscription
  end
  
  def subscribed_to? party
    subscribed_urls.include? party.url
    # I would like it to be subscriptions.has_one_for? party
  end
  
  def find_missing_from parties
    urls = subscribed_urls
    parties.find_all{|p| !urls.include? p.url}
    # I would like it to be subscriptions.missing parties
  end
  
  def remove_expired_subscriptions parties
    party_urls = parties.map{|p| p.url}
    expireds = subscriptions.find_all{|s| !party_urls.include? s.party_url}
    expireds.each do |expired|
      expired.delete
    end
    # I would like it to be subscriptions.remove_expired
  end

  def self.parse params
    name = params[:name]
    email = params[:email]
    friends = params[:friends].values.find_all{ |f| f if !f.empty? }
    Nightclubber.new name, email, friends
  end
  
  def self.empty
    Nightclubber.new('', '', ['', '', '', ''])
  end

  def self.sorted_names
    Nightclubber.all.inject([]){|names, dude|names+[dude.name]+dude.friends}.sort
  end
  
  def self.find email
    Nightclubber.where(:email => email).to_a.first
  end
  
  def self.all_subscribed
    emails = Report.all.map{ |r| r.email }
    Nightclubber.all.find_all{ |c| emails.include? c.email }
  end
  
  def self.all_not_subscribed
    Nightclubber.all.to_a - Nightclubber.all_subscribed
  end
  
  def self.next_to_subscribe parties
    candidates = Nightclubber.need_subscription parties
    return [] if candidates.empty?
    
    winner = candidates.first
    return winner if winner.updated_at.nil?
    
    candidates.each do |c|
      winner = (c.updated_at.nil?) ? 
        c : (c.updated_at < winner.updated_at) ? c : winner
    end
    winner
  end
  
  def self.need_subscription parties
    Nightclubber.all.to_a.find_all do |clubber|
      !clubber.find_missing_from(parties).empty?
    end
  end
  
  private
  
  def subscribed_urls
    subscriptions.map{|s| s.party_url}
  end

end

