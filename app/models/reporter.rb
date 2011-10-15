class Reporter

  def save club, party, clubber, response
    Report.new(
      club.name,
      party.name,
      clubber.name,
      response.code,
      response.message).save
  end

  def clean
    Report.delete_all
  end

  def reports
    Report.all.map{ |r| r.to_s }
  end

end

