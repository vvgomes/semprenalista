class Party

  attr_accessor :name

  def initialize nav
    n = nav.navigate_to_list
    @list = n ? DiscountList.new(n) : nil
    @name = nav.find_name
  end

  def nice?
    !@list.nil?
  end

  def add_to_list clubber
    @list.add clubber
  end
end

