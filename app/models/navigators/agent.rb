require 'mechanize'

module Agent
  def get url
    m.get url
  end

  def submit form
    m.submit
  end

  def m
    @m = Mechanize.new if !@m
    @m
  end
end

