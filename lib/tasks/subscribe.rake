task :subscribe => :environment do
  Nightclub.all.each do |club|
    user = Ticket.next(club).user
    puts club.subscribe(user)
    user.issue_ticket(club)
  end
end

