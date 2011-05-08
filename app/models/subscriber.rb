class Subscriber
  
  def initialize
    @nightclubs = []
    @nightclubbers = []
  end
  
  def add clubber
    @nightclubbers << clubber
  end
  
  def add_nightclub club
    @nightclubs << club
  end
  
  def subscribe clubber
    @nightclubs.each do |club|
      club.add_to_available_lists clubber
    end
  end
  
  def subscribe_everybody
    @nightclubbers.each do |clubber|
      subscribe clubber
    end
  end

end