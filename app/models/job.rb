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
    log "Subscribing #{clubber.email}..."
    Nightclub.all.each do |club|
      club.parties.each do |party|
        begin
          response = party.add_to_list clubber
          save_report(club, party, clubber, response)
        rescue
          begin
            log "Error adding #{clubber.email} to #{club.name} - #{party.name}."
            log "Trying again..."
            response = party.add_to_list clubber
            save_report(club, party, clubber, response)
          rescue => e  
            log "Unable to add #{clubber.email} to #{club.name} - #{party.name}."
            log "Reason: #{e}"
          end
        end  
      end
    end
    log "Done."
  end
  
  def everybody_subscribed
    Report.delete_all if monday?
    log 'Everybody is subscribed to all lists already.'
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
  
  def log message
    puts ">>> #{message}"
  end

end

