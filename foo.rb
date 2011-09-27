require 'rubygems'
require 'mechanize'

agent = Mechanize.new
home = agent.get 'http://www.cabaretpoa.com.br'
link = home.link_with(:href => 'agenda.htm')
puts '##'
require 'ruby-debug';debugger
puts '##'

