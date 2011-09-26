require 'rubygems'
require './app/models/cabaret'

agent = Mechanize.new
agenda = Cabaret::Agenda.new agent.get 'http://www.cabaretpoa.com.br/agenda.htm'
agenda.parties.each do |party|
  puts party.name
end

