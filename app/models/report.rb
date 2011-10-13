require 'mongoid'

class Report
  include Mongoid::Document
  field :club, :type => String
  field :party, :type => String
  field :clubber, :type => String
  field :code => Integer
  field :message => String

  def initialize club, party, clubber, code, message
    super(
      :club => club,
      :party => party,
      :clubber => clubber,
      :code => code,
      :message => message)
  end

end

