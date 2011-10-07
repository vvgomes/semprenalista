require 'mechanize'

module Beco
  URL = 'http://www.beco203.com.br/capa-beco.php'

  def agent
    @agent = Mechanize.new if !@agent
    @agent
  end

  class Navigator
    include Beco

    def initialize
      @page = agent.get URL
    end

    def navigate_to_parties
      links = @page.links_with(:href => /agenda-beco.php?c=/i)
      links.map{ |l| PartyNavigator.new(l.click) }
    end
  end

  class PartyNavigator
    def initialize page
      @page = page
    end

    def find_name
      @page.search('div.conteudo-interna h1 strong').first.text.strip
    end

    def navigate_to_list
      link = @page.link_with('div.conteudo-interna a.nomenalista').first
      link ? DiscountListNavigator.new(link.click) : nil
    end
  end

  class DiscountListNavigator
    include Beco

    def initialize page
      #@form = page.form_with(:action => /cadastra.php/i)
    end

    def fill_name name
      #@form['name'] = name
    end

    def fill_email email
      #@form['email'] = email
    end

    def fill_friends friends
      #fields = @form.fields_with(:name => /amigo/i)
      friends.each_with_index do |friend, i|
        fields[i].value = friend
      end
    end

    def submit
      response_page = agent.submit @form
      ResponseNavigator.new(response_page)
    end
  end

  class ResponseNavigator

  end
end

