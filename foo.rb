require 'rubygems'
require 'mechanize'

agent = Mechanize.new
page = agent.get 'http://cabaretpoa.com.br/rockpocket.htm'
puts page.link_with(:text => /enviar nome para a lista/i).nil?
#other = agent.get url
#puts other

