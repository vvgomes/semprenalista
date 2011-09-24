require 'mechanize'

module Cabaret

  class Party

    def initialize url
      agent = Mechanize.new
      @page = agent.get url
    end

    def name
      @page.search('div#texto > h2').first.text
    end

    def nice?
      !@page.link_with(:text => /enviar nome para a lista/i).nil?
    end

  end

  class DiscountList

    def initialize url
      agent = Mechanize.new
    end

    def add clubber

    end

  end

end

