require File.expand_path(File.dirname(__FILE__) + '/agent')

module Casadolado
  extend Agent

  def self.home
    'http://www.casadolado.com.br'
  end
  
  class Navigator
    def initialize
      @page = Casadolado.get 'agenda.htm'
    end

    def name
      'Casadolado'
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
      @page.search('div#texto > h1').first.text.strip
    end

    def url
      @page.uri.to_s
    end

    def navigate_to_list
      iframe = @page.iframes.first
      iframe ? DiscountListNavigator.new(Casadolado.get(iframe.uri)) : nil
    end
    
  end

  class DiscountListNavigator
    def initialize page
      @form = page.forms.first
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
      response_page = Casadolado.submit @form
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
      @page.search('div#retornoform').first.text.strip
    end
  end
end
