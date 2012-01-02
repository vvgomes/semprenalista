class Nightclub
  
  def initialize nav
    @nav = nav
  end

  def name
    @nav.name
  end

  def parties
    navs = @nav.navigate_to_parties
    all = navs.map{ |n| Party.new(n) }
    all.find_all{ |p| p.nice? }
  end
  
  def ==(other)
    name == other.name
  end
  
  def self.all
    begin
      return @@nightclubs
    rescue
      @@nightclubs = [
        Nightclub.new(Beco::Navigator.new), 
        Nightclub.new(Cabaret::Navigator.new)
      ]
      all
    end
  end

end

