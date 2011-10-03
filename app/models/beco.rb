require 'mechanize'

module Beco

  def nav
    @nav = Navigator.new if !@nav
    @nav
  end


  class Home
    include Beco

    def initialize
      home_page = nav.navigate_to_home
      agenda_page = nav.navigate_to_agenda_from home_page
      @agenda = Agenda.new agenda_page
    end

    def parties
      @agenda.parties.find_all{ |p| p.nice? }
    end

  end

  class Agenda
    include Beco

    def initialize page
      @page = page
    end

    def parties
      []
    end

  end

  class Party
    include Beco

    def initialize page

    end

  end

  # discount list
  # response
  # emptyResponse

  class Navigator

    def initialize
      @agent = Mechanize.new
    end

    def navigate_to_home
      @agent.get 'http://www.beco203.com.br'
    end

    def navigate_to_agenda_from home_page
      home_page.link_with(:href => 'capa-beco.php').click
    end

  end

end

