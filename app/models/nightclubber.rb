require 'mongoid'

class Nightclubber
  include Mongoid::Document 
  field :name, :type => String
  field :email, :type => String
  field :friends, :type => Array, :default => []

  def initialize name, email, friends
    super :name => name, :email => email, :friends => friends
  end

end
