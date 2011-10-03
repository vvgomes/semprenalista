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
      parties = nav.navigate_to_parties_from @page
      parties.map{ |page| Party.new page }
    end

  end

  class Party
    include Beco
    attr_accessor :name

    def initialize page
      @name = nav.find_party_name_for page
      list_page = nav.navigate_to_list_from page
      @list = list_page ? DiscountList.new(list_page) : nil
    end

    def fine?
      @list && @list.fine?
    end

    def add_to_list clubber
      @list.add clubber
    end

  end

  class DiscountList
    include Beco

    def fine?
      true
    end

  end

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

    def navigate_to_parties_from agenda_page
      links = agenda_page.links_with(:href => /agenda-beco.php?c=/i)
      links.map{ |l| l.click }
    end

    def find_party_name_for party_page
      party_page.search('div.conteudo-interna h1 strong').first.text
    end

    def navigate_to_list_from party_page
      result = party_page.search('div.conteudo-interna a.nomenalista')
      link = result ? result.first.click : nil
    end

  end

end

