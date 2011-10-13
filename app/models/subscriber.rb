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

  def subscribe people
    people = [people] if people.class != Array
    @nightclubs.each do |club|
      club.parties.each do |party|
        people.each do |dude|
          response = party.add_to_list dude
        end
      end
    end
  end

  def subscribe_everybody
    everybody = Nightclubber.all
    subscribe everybody
  end

end

