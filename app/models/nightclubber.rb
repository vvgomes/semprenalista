require 'mongoid'

class Nightclubber
  include Mongoid::Document
  field :name, :type => String
  field :email, :type => String
  field :friends, :type => Array, :default => []

  validates_uniqueness_of :email

  def initialize name, email, friends
    super :name => name, :email => email, :friends => friends
  end

  def self.parse params
    name = params[:name]
    email = params[:email]
    friends = params[:friends].values.find_all{ |f| f if !f.empty? }
    Nightclubber.new name, email, friends
  end

  def self.sorted_names
    Nightclubber.all.inject([]){|names, dude|names+[dude.name]+dude.friends}.sort
  end

  def self.empty
    Nightclubber.new('', '', ['', '', '', ''])
  end

end

