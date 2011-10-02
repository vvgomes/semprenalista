require 'mechanize'

module Cabaret

  def nav
    @nav = Navigator.new if !@nav
    @nav
  end

  class Home
    include Cabaret

    def initialize
      home_page = nav.navigate_to_home
      agenda_page = nav.navigate_to_agenda_from home_page
      @agenda = Agenda.new agenda_page
    end

    def parties
      @agenda.parties.find_all{ |p| p.nice? }
    end
  end

  class Agenda
    include Cabaret

    def initialize page
      @page = page
    end

    def parties
      parties = nav.navigate_to_parties_from @page
      parties.map{ |page| Party.new page }
    end

  end

  class Party
    include Cabaret
    attr_accessor :name

    def initialize page
      @name = nav.find_party_name_for page
      @list = nav.navigate_to_list_from page
    end

    def nice?
      !@list.nil?
    end

    def add_to_list clubber
      @list.add clubber
    end

  end

  class DiscountList
    include Cabaret

    def initialize page
      @form = nav.find_form_for page
    end

    def add clubber
      return EmptyResponse.new('Form not found!') if @form.nil?
      fill_form clubber
      submit_form
    end

    private

    def fill_form clubber
      @form['name'] = clubber.name
      @form['email'] = clubber.email

      friends = clubber.friends
      friend_fields = nav.friend_fields_for @form

      friends.each_with_index do |friend, i|
        friend_fields[i].value = friend
      end
    end

    def submit_form
      Response.new(nav.submit @form)
    end

  end

  class Response
    include Cabaret
    attr_reader :code, :message

    def initialize page
      @code = page.code
      @message = nav.find_message_for page
    end

  end

  class EmptyResponse
    attr_reader :code, :message

    def initialize message
      @message = message
      @code = 0
    end

  end

  class Navigator

    def initialize
      @agent = Mechanize.new
    end

    def navigate_to_home
      @agent.get 'http://www.cabaretpoa.com.br/'
    end

    def navigate_to_agenda_from home_page
      home_page.link_with(:href => 'agenda.htm').click
    end

    def navigate_to_parties_from agenda_page
      links = agenda_page.links_with(:text => /saiba mais/i)
      links.map{ |l| l.click }
    end

    def find_party_name_for party_page
      party_page.search('div#texto > h2').first.text
    end

    def navigate_to_list_from party_page
      link = party_page.link_with(:text => /enviar nome para a lista/i)
      link ? link.click : nil
    end

    def find_form_for list_page
      list_page.form_with(:action => /cadastra.php/i)
    end

    def find_friend_fields_for form
      form.fields_with(:name => /amigo/)
    end

    def submit form
      @agent.submit form
    end

    def find_message_for response_page
      response_page.search('body').first.text
    end

  end

end

