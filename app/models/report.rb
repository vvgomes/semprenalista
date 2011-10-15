require 'mongoid'

class Report
  include Mongoid::Document

  field :time, :type => Time
  field :club, :type => String
  field :party, :type => String
  field :clubber, :type => String
  field :code => Integer
  field :message => String

  def initialize club, party, clubber, code, message
    super(
      :time => Time.now,
      :club => club,
      :party => party,
      :clubber => clubber,
      :code => code,
      :message => message
    )
  end

  def to_s
    "#{formated_time} - #{club} - #{party} - #{clubber} and friends - #{code} - [#{message}]"
  end

  private

  def formated_time
    time.getlocal.strftime("%d/%m/%Y %I:%M%p")
  end

end

