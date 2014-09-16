class AddGuestJob
  def initialize(club)
    @club = club
  end

  def run
    info "starting..."
    User.guest_line(@club).each do |user|
      status = @club.add_guest(user)
      info "#{user.email} => #{status}"
      status == 204 ? next : break
    end
    info "done."
  end

  private

  def info(msg)
    Rails.logger.info("[AddGuestJob.run(#{@club.name})]: #{msg}")
  end
end

