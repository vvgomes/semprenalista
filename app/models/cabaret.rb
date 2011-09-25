require 'mechanize'

module Cabaret

  def agent
    @agent = Mechanize.new if !@agent
    @agent
  end

  class Party
    include Cabaret

    def initialize url
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
    include Cabaret

    def initialize url
      @page = agent.get url
      @form = @page.form_with(:action => /cadastra.php/i)
    end

    def nice?
      !@form.nil?
    end

    def add clubber
      return if !nice?
      @form[:name] = clubber.name
      @form[:email] = clubber.email
      add_friends clubber
      #response = agent.submit form
      #log list_link.href, clubber, response.code
    end

    private

    def add_friends clubber
      fields_for_friends = @form.fields_with(:name => /amigo/)
      clubber.friends.each_with_index do |friend, i|
        fields_for_friends[i].value = friend
      end
    end

  end

end

