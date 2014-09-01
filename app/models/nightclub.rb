class Nightclub
  attr_reader :name

  def initialize(name, partybot)
    @name, @partybot = name, partybot
  end

  def parties(filters={})
    @partybot.parties(filters).map{ |raw| Party.new(raw) }
  end

  def subscribe(user, parties)
    @partybot.subscribe(user.to_h, parties.map(&:public_id))
  end

  def ==(other)
    self.name == other.name
  end

  class << self
    def all
      @all ||= ['Beco', 'Cucko', 'Lab'].map do |name|
        new(name, ENV[name.upcase]+'.herokuapp.com')
      end
    end
  end
end
