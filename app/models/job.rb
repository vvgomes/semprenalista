class Job
  
  def run email=nil
    if clubber = find_clubber(email)
      subscribe clubber 
    else  
      everybody_subscribed  
    end  
  end

  private
  
  def find_clubber email
    return not_subscribed_yet if !email
    Report.where(:email => email).delete_all
    Nightclubber.where(:email => email).first
  end
  
  def not_subscribed_yet
    Nightclubber.all.to_a.find do |clubber|
      Report.where(:email => clubber.email).count == 0
    end
  end
  
  def subscribe clubber
    Nightclub.all.each do |club|
      club.parties.each do |party|
        response = party.add_to_list clubber
        save_report(club, party, clubber, response)
      end
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

