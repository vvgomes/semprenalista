require 'mechanize'
require 'logger'

class Nightclub
  
  def initialize config
    @config = config
    @logger = Logger.new STDOUT
  end
  
  def add_to_available_lists clubber
    agent = Mechanize.new
    agent.get @config[:home_page]
    agent.page.links_with(:href => @config[:links]).each do |list_link|
      list_link.click
      form = agent.page.form_with :action => @config[:service]
      form[@config[:param_names][:name]] = clubber.name
      form[@config[:param_names][:email]] = clubber.email
      fields_for_friends = form.fields_with :name => @config[:param_names][:friends]
      clubber.friends.each_with_index do |friend, i|
        fields_for_friends[i].value = friend
      end
      response = agent.submit form
      log list_link.href, clubber, response.code
    end
  end
  
  def turn_logger_off
    @logger = nil
  end
  
  private
  
  def log list, clubber, code
    @logger.info "Added #{clubber.name} (#{clubber.email}) in #{list}: #{code}" if @logger
  end
  
end