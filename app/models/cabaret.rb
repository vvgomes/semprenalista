require 'mechanize'

module Cabaret
  URL = 'http://www.cabaretpoa.com.br'

  def agent
    @agent = Mechanize.new if !@agent
    @agent
  end

  class HomeNavigator
    include Cabaret

    def initialize
      @page = agent.get URL
    end

    def navigate_to_agenda
      agenda_link = @page.link_with(:text => /agenda/i)
      agenda_page = agenda_link.click
      AgendaNavigator.new agenda_page
    end
  end

  class AgendaNavigator
    def initialize page
      @page = page
    end

    def navigate_to_parties
      links = @page.links_with(:text => /saiba mais/i)
      links.map{ |l| PartyNavigator.new(l.click) }
    end
  end

  class PartyNavigator
    def initialize page
      @page = page
    end

    def find_name
      @page.search('div#texto > h2').first.text.strip
    end

    def navigate_to_list
      link = @page.link_with(:text => /enviar nome para a lista/i)
      link ? DiscountListNavigator.new(link.click) : nil
    end
  end

  class DiscountListNavigator
    include Cabaret

    def initialize page
      @form = page.form_with(:action => /cadastra.php/i)
    end

    def fill_name name
      @form['name'] = name
    end

    def fill_email email
      @form['email'] = email
    end

    def fill_friends friends
      fields = @form.fields_with(:name => /amigo/i)
      friends.each_with_index do |friend, i|
        fields[i].value = friend
      end
    end

    def submit
      response_page = agent.submit form
      ResponseNavigator.new(response_page)
    end
  end

  class ResponseNavigator
    def initialize page
      @page = page
    end

    def code
      @page.code
    end

    def find_message
      @page.search('body').first.text.trim
    end
  end
end

