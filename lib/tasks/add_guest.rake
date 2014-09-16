task :subscribe => :environment do
  Nightclub.all.each do |club|
    user = Ticket.next(club).user
    parties = club.parties(:missing => user)
    puts club.subscribe(user, parties)
    user.issue_ticket(club)
  end
end

