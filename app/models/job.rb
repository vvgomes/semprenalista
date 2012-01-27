class Job
  
  def run email=nil
    log '1'
    parties = Party.all
    log '2'
    clubber = find email, parties
    log '3'
    return log('Everybody is already subscribed \o/') unless clubber
    log '4'
    clubber.remove_expired_subscriptions parties
    log '5'
    subscribe clubber, parties
    log '6'
  end
  
  private
  
  def find email, parties
    email ? Nightclubber.find_by(email) : Nightclubber.next_to_subscribe(parties)
  end
  
  def subscribe clubber, parties
    clubber.find_missing_from(parties).each do |party|
      begin
        log "Subscribing #{clubber.email} to #{party.name}..."
        response = party.add_to_list clubber
        clubber.add Subscription.new(party, response)
        clubber.save
        log 'OK.'
      
      rescue => e  
        log "Unable to add #{clubber.email} to #{party.name}."
        log "Reason: #{e}"
      end
    end
    log 'Done.' 
  end
  
  def log message
    puts "[JOB] #{message}"
  end

end

