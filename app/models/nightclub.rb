require 'mechanize'

class Nightclub
  
  def initialize config
    @config = config
  end
  
  def add_to_available_lists clubber
    agent = Mechanize.new
    agent.get @config[:home_page]
    agent.page.links_with(:href => @config[:links]).each do |party_link|
      party_link.click
      form = agent.page.form_with :action => @config[:service]
      form[@config[:param_names][:name]] = clubber.name
      form[@config[:param_names][:email]] = clubber.email
      fields_for_friends = form.fields_with :name => @config[:param_names][:friends]
      clubber.friends.each_with_index do |friend, i|
        fields_for_friends[i].value = friend
      end
      agent.submit form
    end
  end
  
end