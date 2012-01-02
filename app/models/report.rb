require 'mongoid'

class Report
  include Mongoid::Document

  field :time, :type => Time
  field :club, :type => String
  field :party, :type => String
  field :email, :type => String
  field :code => Integer
  field :message => String

  def initialize club, party, email, code, message
    super(
      :time => Time.now,
      :club => club,
      :party => party,
      :email => email,
      :code => code,
      :message => message
    )
  end

  def to_s
    "#{formated_time} - #{club} - #{party} - #{email} - #{code} - [#{message}]"
  end

  private

  def formated_time
    time.getlocal.strftime("%d/%m/%Y %I:%M%p")
  end

end

