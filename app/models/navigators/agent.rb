require 'mechanize'

module Agent
  
  def get resource
    m.get "#{home}/#{resource}"
  end

  def submit form
    form.encoding = 'utf-8'
    m.submit form
  end

  def m
    @m = Mechanize.new unless @m
    @m
  end
  
  def home
    ''
  end
  
end

