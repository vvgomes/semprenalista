class Party

  attr_accessor :name, :url

  def initialize nav
    n = nav.navigate_to_list
    @list = n ? DiscountList.new(n) : nil
    @name = nav.find_name
    @url = nav.url
    @nav = nav
  end

  def nice?
    !@list.nil?
  end
  
  def add_to_list clubber
    @list.add clubber
  end

  def reset_agent
    @nav.reset_agent
  end
  
end

