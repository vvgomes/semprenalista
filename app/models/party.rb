class Party

  attr_accessor :name, :url

  def initialize nav
    @name = nav.find_name
    @url = nav.url
    
    n = nav.navigate_to_list
    @list = DiscountList.new(n) if n
  end

  def nice?
    !@list.nil?
  end
  
  def add_to_list clubber
    @list.add clubber
  end
  
  def ==(other)
    other.url == @url
  end
  
  def self.all
    Nightclub.all.inject([]){ |parties, club| parties + club.parties }
  end
  
end

