class AddGuestJob
  def self.run(club)
    User.guest_line(club).each do |user|
      club.add_guest(user) == 204 ? next : break
    end
  end
end

