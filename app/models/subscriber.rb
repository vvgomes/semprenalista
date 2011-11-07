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
    people = [people] if people.class == Nightclubber
    @nightclubs.each do |club|
      club.parties.each do |party|
        people.each do |dude|      
          if !subscribed?(club.name, party.name, dude.name) 
            response = party.add_to_list dude
            save_report(club, party, dude, response)
          end
        end
      end
    end
  end

  def subscribe_everybody
    Report.delete_all
    subscribe Nightclubber.all.reverse
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
  
  def subscribed? club_name, party_name, clubber_name
    Report.where(:club => club_name).and(:party => party_name).and(:clubber => clubber_name).size > 0
  end
  
end

