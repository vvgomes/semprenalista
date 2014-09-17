class AddGuestJob
  def initialize(club)
    @club = club
  end

  def run
    log "starting..."
    User.guest_line(@club).each do |user|
      status = @club.add_guest(user)
      log "#{user.email} => #{status}"
      status == 204 ? next : break
    end
    log "done."
  end

  private

  def log(msg)
    Rails.logger.info("AddGuestJob[#{@club.name}]: #{msg}")
  end
end

