require 'mechanize'

module Agent
  def get url
    m.get url
  end

  def submit form
    m.submit form
  end

  def m
    @m = Mechanize.new if !@m
    @m
  end
  
end

