class Subscriber
  
  def initialize
    @nightclubs = []
  end
  
  def add clubber
    clubber.save
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
    Nightclubber.all.each do |clubber|
      subscribe clubber
    end
  end

end