class Subscriber

  def initialize reporter
    @reporter = reporter
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
          @reporter.save(club, party, dude, response)
        end
      end
    end
  end

  def subscribe_everybody
    @reporter.clean
    everybody = Nightclubber.all
    subscribe everybody
  end

end

