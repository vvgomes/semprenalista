class Job

  def cron
    run if monday?
  end
  
  def run
    
  end

  def initialize subscriber
    @subscriber = subscriber
  end

  def run
    Report.delete_all
    people = Nightclubber.all    
    Nightclub.all.each do |club|
      club.parties.each do |party|
        people.each do |dude|      
          response = party.add_to_list dude
          save_report(club, party, dude, response)
        end
      end
    end
  end

  private

  def monday?
    Time.now.wday == 1
  end
  
  def save_report club, party, clubber, response
    Report.new(
      club.name,
      party.name,
      clubber.name,
      response.code,
      response.message).save
  end

end

