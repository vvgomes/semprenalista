require File.expand_path(File.dirname(__FILE__) + '/agent')

module Cabaret
  extend Agent

  HOME = 'http://www.cabaretpoa.com.br'

  class Navigator
    def initialize
      #TODO: can I avoid passing HOME?
      @page = Cabaret.get "#{HOME}/js/agenda.js"
    end

    def name
      'Cabaret'
    end

    def navigate_to_parties
      js = @page.body
      js = remove_comments js
      hrefs(js).map{ |l| PartyNavigator.new(Cabaret.get("#{HOME}/#{l}")) }
    end
    
    private
    
    # move to a new class
    
    def remove_comments js
      js.gsub(/\/\/.+$/, "")
    end
    
    def hrefs js
      js.scan(/href="([^"]+)"/).map{ |r| r.first }
    end
    
  end

  class PartyNavigator
    def initialize page
      @page = page
    end

    def find_name
      @page.search('div#perfil > h2').first.text.strip
    end

    def url
      @page.uri.to_s
    end

    def navigate_to_list
      iframe = @page.iframe_with(:id => 'fr_lista')
      return nil if !iframe
      DiscountListNavigator.new(Cabaret.get("#{HOME}/#{iframe.uri}"))
    end
    
  end

  class DiscountListNavigator
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
      response_page = Cabaret.submit @form
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
      @page.search('body').first.text.strip
    end
  end
end

