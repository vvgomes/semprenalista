require 'rubygems'
require './app/models/cabaret'
require './app/models/nightclubber'

fulvio = Nightclubber.new 'Fulvio Silas', 'fulvio@gmail.com', ['Jairo Silva', 'Gilda Souza']

page = Mechanize.new.get 'http://cabaretpoa.com.br/lista-start-me-up.htm'

list = Cabaret::DiscountList.new page
r = list.add fulvio
pp r

=begin
agent = Mechanize.new
page = agent.get 'http://cabaretpoa.com.br/shuffle.htm'
url = page.link_with(:text => /enviar nome para a lista/i).href
puts url
discount = agent.get url

form = discount.form_with(:action => /cadastra.php/i)
puts form
=end

