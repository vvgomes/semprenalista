require 'observer'

class Reporter

  def save club, party, clubber, response
    Report.new(
      Time.now,
      club.name,
      party.name,
      clubber.name,
      response.code,
      response.message).save
  end

  def clean
    Report.delete_all
  end

end

