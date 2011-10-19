class Subscriber

  attr_reader :nightclubs

  def self.create
    subscriber = Subscriber.new
    subscriber.add Nightclub.new(Cabaret::Navigator.new)
    subscriber.add Nightclub.new(Beco::Navigator.new)
    subscriber
  end

  def initialize
    @nightclubs = []
  end

  def add club
    @nightclubs << club
  end

  def subscribe people
    people = [people] if people.class != Array
    @nightclubs.each do |club|
      club.parties.each do |party|
        people.each do |dude|
          response = party.add_to_list dude
          save_report(club, party, dude, response)
        end
      end
    end
  end

  def subscribe_everybody
    Report.delete_all
    subscribe Nightclubber.all
  end

  def reports
    Report.all.map{ |r| r.to_s }
  end

  private

  def save_report club, party, clubber, response
    Report.new(
      club.name,
      party.name,
      clubber.name,
      response.code,
      response.message).save
  end

end

