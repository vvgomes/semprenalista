require 'mechanize'

module Cabaret

  def agent
    @agent = Mechanize.new if !@agent
    @agent
  end

  class Home
    include Cabaret

    def initialize
      page = agent.get 'http://www.cabaretpoa.com.br/'
      agenda_link = page.link_with :href => 'agenda.htm'
      agenda_page = agenda_link.click
      @agenda = Agenda.new agenda_page
    end

    def parties
      @agenda.parties.find_all{ |p| p.nice? }
    end
  end

  class Agenda

    def initialize page
      @page = page
    end

    def parties
      links = @page.links_with :text => /saiba mais/i
      links.map { |l| Party.new l.click }
    end

  end

  class Party

    def initialize page
      @page = page
      @list_link = @page.link_with :text => /enviar nome para a lista/i
    end

    def name
      @page.search('div#texto > h2').first.text
    end

    def nice?
      !@list_link.nil?
    end

    def add_to_list clubber
      list = DiscountList.new @list_link.click
      list.add clubber
    end

  end

  class DiscountList
    include Cabaret

    def initialize page
      @page = page
      @form = @page.form_with :action => /cadastra.php/i
    end

    def add clubber
      return EmptyResponse.new('Form not found!') if !nice?
      fill_form_with clubber
      submit_form
    end

    private

    def nice?
      !@form.nil?
    end

    def fill_form_with clubber
      @form['name'] = clubber.name
      @form['email'] = clubber.email
      fields_for_friends = @form.fields_with(:name => /amigo/)
      clubber.friends.each_with_index do |friend, i|
        fields_for_friends[i].value = friend
      end
    end

    def submit_form
      Response.new(agent.submit(@form))
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

    def initialize reason
      @reason = reason
    end

    def code
      0
    end

    def body
      @reason
    end

  end

end

