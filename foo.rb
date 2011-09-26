require 'rubygems'

page = Mechanize.new.get 'http://www.cabaretpoa.com.br/agenda.htm'

list = Cabaret::DiscountList.new page
response = list.add fulvio
puts 'hey'
require 'ruby-debug';debugger
puts 'hey'

