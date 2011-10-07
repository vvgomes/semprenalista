class Response

  attr_reader :code

  def initialize nav
    @code = nav.code
    @message = nav.find_message
  end

  def message
    return 'Something went wrong!' if @message.nil?
    @message
  end

end

