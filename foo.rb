require 'rubygems'
require 'mechanize'

agent = Mechanize.new
page = agent.get 'http://cabaretpoa.com.br/shuffle.htm'
url = page.link_with(:text => /enviar nome para a lista/i).href
puts url
discount = agent.get url

form = discount.form_with(:action => /cadastra.php/i)
puts form

