class Job
  
  def run
    clubber = not_subscribed_yet
    if clubber
      subscribe clubber
    else
      Report.delete_all if monday?
    end  
  end

  def run!
    Report.delete_all
    Nightclubber.all.each do |clubber|
      subscribe clubber
    end
  end

  private
  
  def subscribe clubber
    Nightclub.all.each do |club|
      club.parties.each do |party|
        response = party.add_to_list clubber
        save_report(club, party, clubber, response)
      end
    end
  end
  
  def not_subscribed_yet
    Nightclubber.all.find do |clubber|
      Report.where(:email => clubber.email).nil?
    end
  end
  
  def save_report club, party, clubber, response
    Report.new(
      club.name,
      party.name,
      clubber.email,
      response.code,
      response.message).save
  end
  
  def monday?
    Time.now.wday == 1
  end

end

