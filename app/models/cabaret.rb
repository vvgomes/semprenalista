require 'mechanize'

module Cabaret

  def agent
    @agent = Mechanize.new if !@agent
    @agent
  end

  class Party

    def initialize page
      @page = page
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

    def initialize page
      @page = page
      @form = @page.form_with(:action => /cadastra.php/i)
    end

    def nice?
      !@form.nil?
    end

    def add clubber
      return EmptyResponse.new if !nice?
      fill_form_with clubber
      submit
    end

    private

    def fill_form_with clubber
      @form['name'] = clubber.name
      @form['email'] = clubber.email
      fields_for_friends = @form.fields_with(:name => /amigo/)
      clubber.friends.each_with_index do |friend, i|
        fields_for_friends[i].value = friend
      end
    end

    def submit
      response_page = agent.submit @form
      Response.new response_page
    end

  end

  class Response

    def initialize page
      @page = page
    end

    def code
      @page.code
    end

    def body
      @page.search('body').first.text
    end

  end

  class EmptyResponse

    def code
      0
    end

    def body
      'empty response'
    end

  end

end

