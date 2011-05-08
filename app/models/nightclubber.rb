class Nightclubber 
  
  attr_reader :name
  attr_reader :email
  attr_reader :friends
  
  def initialize name, email
    @name = name
    @email = email
    @friends = []
  end
  
  def take friend
    @friends << friend
  end
  
  def alone?
    @friends.empty?
  end
  
end