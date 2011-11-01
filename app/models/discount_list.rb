class DiscountList

  def initialize nav
    @nav = nav
  end

  def add clubber
    @nav.fill_name clubber.name
    @nav.fill_email clubber.email
    @nav.fill_friends clubber.friends
    Response.new(@nav.submit)
    #FakeResponse.new
  end
  
  # I know...
  class FakeResponse
    def code
      200
    end
    def message
      'ok'
    end
  end
  
end

