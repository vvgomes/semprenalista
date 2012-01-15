require File.expand_path(File.dirname(__FILE__) + '/agent')

module Cabaret
  extend Agent

  def self.home
    'http://www.cabaretpoa.com.br'
  end
  
  class Navigator
    def initialize
      @page = Cabaret.get 'js/agenda.js'
    end

    def name
      'Cabaret'
    end

    def navigate_to_parties
      js = JsNavigator.new @page.body
      js.hrefs.map{ |l| PartyNavigator.new(Cabaret.get(l)) }
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
      iframe ? DiscountListNavigator.new(Cabaret.get(iframe.uri)) : nil
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
  
  class JsNavigator
    def initialize code
      @js = remove_comments_from code
    end
    
    def hrefs
      @js.scan(/href="([^"]+)"/).map{ |r| r.first }.inject({}){ |h,l| h[l.to_sym]=l; h }.values
    end
    
    private
    def remove_comments_from code
      single_line = /\/\/.+$/
      multi_line = /\/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+\//
      code.gsub(single_line, '').gsub(multi_line, '')
    end
  end
end

