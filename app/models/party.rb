class Party

  attr_accessor :name, :url

  def initialize nav
    n = nav.navigate_to_list
    @list = n ? DiscountList.new(n) : nil
    @name = nav.find_name
    @url = nav.url
  end

  def nice?
    !@list.nil?
  end
  
  def add_to_list clubber
    @list.add clubber
  end
  
end

