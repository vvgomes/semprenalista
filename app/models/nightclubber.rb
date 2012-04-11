require 'mongoid'

class Nightclubber
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :email, :type => String
  field :friends, :type => Array, :default => []
  
  embeds_many :subscriptions
  
  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  
  validates_format_of :name, :with => /#{'^([a-zA-ZÀ-ú]+\s?)+[a-zA-ZÀ-ú]+$'}/
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validate :validate_friends

  def validate_friends
    return if friends.empty?
    invalids = friends.map{|f|f.match(/#{'^([a-zA-ZÀ-ú]+\s?)+[a-zA-ZÀ-ú]+$'}/)}.select{|e|e.nil?}
    errors.add(:friends, 'Invalid friend(s) name') unless invalids.empty?
  end
  
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
  
  def parse params
    update_attributes(
      :name => params[:name], 
      :friends => params[:friends].values.find_all{ |f| f unless f.empty? })
  end

  def self.parse params
    name = params[:name]
    email = params[:email]
    friends = params[:friends].values.find_all{ |f| f unless f.empty? }
    Nightclubber.new name, email, friends
  end
  
  def self.empty
    Nightclubber.new('', '', ['', '', '', ''])
  end

  def self.sorted_names
    Nightclubber.all.to_a.inject([]){|names, dude|names+[dude.name]+dude.friends}.sort
  end
  
  def self.find_by email
    Nightclubber.where(:email => email).to_a.first
  end
  
  def self.all_subscriptions
    Nightclubber.all.to_a.inject([]) do |all, clubber|
      all + clubber.subscriptions
    end
  end
  
  def self.next_to_subscribe parties
    candidates = Nightclubber.need_subscription parties
    return nil if candidates.empty?
    
    winner = candidates.find { |c| c.updated_at.nil? }
    return winner if winner
    
    candidates.inject(candidates.first) do |winner, candidate|   
      candidate.updated_at < winner.updated_at ? candidate : winner
    end
  end
  
  def self.need_subscription parties
    Nightclubber.all.to_a.find_all do |clubber|
      !clubber.find_missing_from(parties).empty?
    end
  end
  
  def self.missing_emails_with_party_urls parties
    result = []
    Nightclubber.need_subscription(parties).each do |clubber|
      clubber.find_missing_from(parties).each do |party|
        result << {:email => clubber.email, :party_url => party.url}
      end
    end
    result
  end

  private
  
  def subscribed_urls
    subscriptions.map{|s| s.party_url}
  end
  
end

