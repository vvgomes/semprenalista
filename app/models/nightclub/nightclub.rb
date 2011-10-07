module Nightclub

  class Home
    def initialize nav
      @agenda = Agenda.new(nav.navigate_to_agenda)
    end

    def parties
      @agenda.parties.find_all{ |p| p.nice? }
    end
  end

  class Agenda
    def initialize nav
      @nav = nav
    end

    def parties
       @nav.navigate_to_parties.map{ |n| Party.new(n) }
    end
  end

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

  class DiscountList
    def initialize nav
      @nav = nav
    end

    def add clubber
      @nav.fill_name clubber.name
      @nav.fill_email clubber.email
      @nav.fill_friends clubber.friends
      Response.new(@nav.submit)
    end
  end

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

end

