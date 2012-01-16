require File.expand_path(File.dirname(__FILE__) + '/agent')
module Laika
  extend Agent

  def self.home
    'http://laikaclub.com.br/site/'
  end

  class Navigator

    def initialize
      @page = Laika.get 'index.php?option=com_content&view=category&layout=blog&id=1&Itemid=2'
    end

    def navigate_to_parties
      links = @page.links_with(:href => /catid=4:festas&Itemid=4/)
      links = links.inject({}){ |h, l| h[l.href] = l; h}.values
      links.map{ |l| PartyNavigator.new(l.click) }
    end

    def name
      'Laika'
    end
  end

  class PartyNavigator
    def initialize page
      @page = page
    end

    def find_name
      begin
      @page.search('//div/div/table/tbody/tr/td/p/span').first.text.strip
      rescue NoMethodError
        url.match(/id=\d*:([a-z_-]*)/)[1]
      end
    end

    def url
      @page.uri.to_s
    end

    def navigate_to_list
      form = @page.form_with(:action => 'index.php')
      form ? Laika::DiscountListNavigator.new(form) : nil
    end
  end

  class DiscountListNavigator
    def initialize form
      @form = form
    end

    def fill_name name
      @form.fields[1].value = name
    end

    def fill_email email
      @form.fields[0].value = email
    end

    def fill_friends friends
      friends.each_with_index do |friend, i|
        @form.fields[i+2].value = friend
      end
    end

    def submit
      response_page = Laika.submit @form
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
      @page.search('.jform').first.text.strip
    end
  end
end
