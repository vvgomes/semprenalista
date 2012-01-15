class Response

  attr_reader :code

  def initialize nav
    @code = nav.code
    @message = nav.find_message
  end

  def message
    @message || 'Something went wrong!'
  end

end

