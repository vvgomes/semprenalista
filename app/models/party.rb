class Party
  attr_reader :public_id

  def initialize(raw)
    @public_id = raw[:public_id] || raw['public_id']
  end

  def ==(other)
    self.public_id == other.public_id
  end
end
