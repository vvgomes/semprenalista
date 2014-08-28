class Party
  attr_reader :id

  def initialize(raw)
    @id = raw['public_id']
  end
end
