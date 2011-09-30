require 'mechanize'

module Beco

  def agent
    @agent = Mechanize.new if !@agent
  end


  class Home
    include Beco

    def initialize
      page = agent.get 'http://www.beco203.com.br/'
      agenda_link = page.link_with :href => 'capa-beco.php'
      agenda_page = agenda_link.click
      @agenda = Agenda.new agenda_page
    end

    def parties
      @agenda.parties.find_all{ |p| p.nice? }
    end

  end

  class Agenda

    def initialize page
      @page = page
    end

  end

end

