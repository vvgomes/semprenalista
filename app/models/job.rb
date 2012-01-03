class Job
  
  def run
    if clubber = not_subscribed_yet 
      subscribe clubber 
    else  
      everybody_subscribed  
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
  
  def everybody_subscribed
    Report.delete_all if monday?
    log 
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
  
  def log
    puts 'Everybody is subscribed to all lists already.'
  end

end

